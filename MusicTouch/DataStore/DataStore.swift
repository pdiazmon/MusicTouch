//
//  DataStore.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 24/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer
import PDMUtils

struct MediaLibraryCache {
  var playlistList: [MTPlaylistData] = []
  var artistList:   [MTArtistData]   = []
  var albumList:    [MTAlbumData]    = []
  var songList:     [MTSongData]     = []
}

/// Music Library wrapper to make it easy for the rest of the classes to request music items
class DataStore: DataStoreProtocol {
    private var cache = MediaLibraryCache()
  
    private var _artistList:           [MTArtistData]
    private var _playlistList:         [MTPlaylistData]
    private var _albumList:            [MTAlbumData]
    private var _songList:             [MTSongData] 
    private var lastArtist:            String?
    private var lastSongByArsitsAlbum: (String, String)?
    private var lastSongByPlaylist:    String?
    
    let playlistSemaphore = DispatchSemaphore(value: 1)
    let artistSemaphore   = DispatchSemaphore(value: 1)
    let albumSemaphore    = DispatchSemaphore(value: 1)
    let songSemaphore     = DispatchSemaphore(value: 1)
    
    let datastoreQueue = DispatchQueue(label: "datastore")
    
    // Default size for artwork items
    let size = 250.0

    init() {
        _artistList   = []
        _playlistList = []
        _albumList    = []
        _songList     = []
        
        fillCache()
    }
}

// MARK: RefreshList methods
extension DataStore {
    func fillCache() {
      
        // Fill playlist cache
        datastoreQueue.async {
            self.playlistSemaphore.wait()
            self.cache.playlistList = []
            for item in PDMMediaLibrary.getPlaylistList() {
                
                let name = item.value(forProperty: MPMediaPlaylistPropertyName) as! String
                let playlistSongs = PDMMediaLibrary.getSongsList(byPlaylist: name)
                
                let playlist = MTPlaylistData(image: item.representativeItem?.artwork == nil ? nil : (item.representativeItem?.artwork?.image(at: CGSize(width: self.size, height: self.size)))!,
                                                    name: name)
                
                // Add to the playlist all its songs ..
                for song in playlistSongs {
                    playlist.songs.append(MTSongData(mediaItem: song))
                }
            
                // .. and sort them by album title and song track number
                playlist.songs =  playlist.songs.sorted {
                    if $0.mediaItem.albumTitle! == $1.mediaItem.albumTitle! {
                        return $0.mediaItem.albumTrackNumber < $1.mediaItem.albumTrackNumber
                    } else {
                        return $0.mediaItem.albumTitle! < $1.mediaItem.albumTitle!
                    }
                }
                
                // add it to the cache
                self.cache.playlistList.append(playlist)
            }
            self.playlistSemaphore.signal()
        }
        
        // Get all the artists, and their albums and albums' songs
        datastoreQueue.async {
            self.artistSemaphore.wait()
            self.albumSemaphore.wait()
            self.songSemaphore.wait()
            
            let allAlbums  = PDMMediaLibrary.getAlbumsList()
            let allSongs   = PDMMediaLibrary.getSongsList()
            
            self.cache.artistList = PDMMediaLibrary.getArtistList().map {
                let artist = MTArtistData(image: $0.artwork == nil ? nil : ($0.artwork?.image(at: CGSize(width: self.size, height: self.size)))!,
                                          name: $0.albumArtist!)
                
                artist.albums = allAlbums.filter { artist.name == $0.albumArtist }.map {
                    let album = MTAlbumData(image: $0.artwork == nil ? nil : ($0.artwork?.image(at: CGSize(width: self.size, height: self.size))),
                                            artistName: $0.artist!,
                                            albumTitle: $0.albumTitle!,
                                            year: ($0.releaseDate != nil) ? Calendar.current.component(.year, from: $0.releaseDate!) : ALBUMYEAR_DEFAULT)
                    
                    album.songs = allSongs.filter { $0.albumArtist == artist.name && $0.albumTitle == album.albumTitle }
                                          .map { MTSongData(mediaItem: $0) }
                                          .sorted { return $0.mediaItem.albumTrackNumber < $1.mediaItem.albumTrackNumber }
                
                    return album
                }
                .sorted {
                        return $0.year < $1.year
                }
                
                return artist
            }
            
            self.artistSemaphore.signal()
          
            // Cache all the albums
            self.cache.albumList = self.cache.artistList.flatMap { $0.albums }
            self.albumSemaphore.signal()
          
            // Cache all the songs
            self.cache.songList = self.cache.albumList.flatMap { $0.songs }
            self.songSemaphore.signal()
        }
    }
  
  
    /// Reads the artists from the music library and store them in the data-store artist list
    func refreshArtistList() {
        // We do not expect the music library changes during the app execution.
        // So, if the data-store artist list is already filled, do nothing
        guard (_artistList.count == 0) else { return }
      
        artistSemaphore.wait()
        _artistList = cache.artistList
        artistSemaphore.signal()
    }
    
    /// Reads the playlists from the music library and store them in the data-store playlist list
    func refreshPlaylistList() {
        // We do not expect the music library changes during the app execution.
        // So, if the data-store playlist list is already filled, do nothing
        guard (_playlistList.count == 0) else { return }

        playlistSemaphore.wait()
        _playlistList = cache.playlistList
        playlistSemaphore.signal()
    }
    
    /// Refresh the albums from the music library, filtering by artist name, and store them in the data-store album list
    ///
    /// - Parameter byArtist: artist name
    func refreshAlbumList(byArtist: String) {
        // If the album list refresh requested is the same as the last time, we don't need to do it again
        guard (lastArtist == nil || lastArtist! != byArtist) else { return }
        
        albumSemaphore.wait()

        _albumList = []
        lastArtist = byArtist
        
        if (byArtist.count > 0) {
            _albumList = cache.albumList.filter { $0.artistName == byArtist }
        }
        else {
            _albumList = cache.albumList
        }
        
        albumSemaphore.signal()
    }
    
    /// Refresh the songs from the music library, filtering by artist name and album title, and store them in the data-store song list
    ///
    /// - Parameters:
    ///   - byArtist: artist name
    ///   - byAlbum: album title
    func refreshSongList(byArtist: String, byAlbum: String = "") {
        
        // If the song list refresh requested is the same as the last time, we don't need to do it again
        guard (lastSongByArsitsAlbum == nil || lastSongByArsitsAlbum! != (byArtist, byAlbum)) else { return }
        
        songSemaphore.wait()

        lastSongByArsitsAlbum = (byArtist, byAlbum)
        
        _songList = []
      
        // If only an artist name is given, without an album title
        if (byArtist.count > 0 && byAlbum.count == 0) {
            _songList = cache.songList.filter { $0.mediaItem.albumArtist == byArtist }
        }
        // If an artist name and an album title are given
        else if (byArtist.count > 0 && byAlbum.count > 0) {
            _songList = cache.songList.filter { $0.mediaItem.albumArtist == byArtist && 
                                                $0.mediaItem.albumTitle  == byAlbum }
        }
        // In any other case
        else {
            _songList = cache.songList
        }

        _songList = _songList.sorted {
            if $0.mediaItem.albumArtist! == $1.mediaItem.albumArtist! {
                if $0.mediaItem.albumTitle! == $1.mediaItem.albumTitle! {
                    return $0.mediaItem.albumTrackNumber < $1.mediaItem.albumTrackNumber
                } else {
                    return $0.mediaItem.albumTitle! < $1.mediaItem.albumTitle!
                }
            }
            else {
                return $0.mediaItem.albumArtist! < $1.mediaItem.albumArtist!
            }
        }
        
        songSemaphore.signal()
    }
    
    /// Refresh the songs from the music library, filtering by playlist name, and store them in the data-store song list
    ///
    /// - Parameter byPlaylist: playlist name
    func refreshSongList(byPlaylist: String) {
        
        // If the song list refresh requested is the same as the last time, we don't need to do it again
        guard (lastSongByPlaylist == nil || lastSongByPlaylist! != byPlaylist) else { return }
        
        songSemaphore.wait()
        playlistSemaphore.wait()
        
        lastSongByPlaylist = byPlaylist
        
        let playlist = cache.playlistList.filter{ $0.name == byPlaylist }.first
        
        if let playlist = playlist {
            _songList = playlist.songs
        }
        
        _songList = _songList.sorted {
            if $0.mediaItem.albumTitle! == $1.mediaItem.albumTitle! {
                return $0.mediaItem.albumTrackNumber < $1.mediaItem.albumTrackNumber
            } else {
                return $0.mediaItem.albumTitle! < $1.mediaItem.albumTitle!
            }
        }
        
        playlistSemaphore.signal()
        songSemaphore.signal()
        
    }
    
    /// Refresh the songs list from the current album list
    func refreshSongListFromAlbumList() {
        songSemaphore.wait()
        albumSemaphore.wait()
        
        _songList = _albumList.flatMap { $0.songs }
        
        albumSemaphore.signal()
        songSemaphore.signal()
    }

}

// MARK: return list
extension DataStore {
    
    /// Returns the songs list stored in the data-store object
    ///
    /// - Returns: songs list
    func songList() -> [MTSongData] {
        return _songList
    }
    
    /// Returns the songs list stored in the data-store object as a MPMediaItemCollection object
    ///
    /// - Returns: songs list
    func songCollection() -> MPMediaItemCollection {
        return MPMediaItemCollection(items: _songList.map { $0.mediaItem })
    }

    
    /// Returns the albums list stored in the data-store object
    ///
    /// - Returns: albums list
    func albumList() -> [MTAlbumData] {
        return _albumList
    }

    /// Returns the playlists list stored in the data-store object
    ///
    /// - Returns: playlists list
    func playlistList() -> [MTPlaylistData] {
        return _playlistList
    }
    
    /// Returns the artists list stored in the data-store object
    ///
    /// - Returns: artists list
    func artistList() -> [MTArtistData] {
        return _artistList
    }

}

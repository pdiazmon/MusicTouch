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

    func describe() {
        for playlist in playlistList {
            playlist.describe(offset: 0)
        }
        
        for artist in artistList {
            artist.describe(offset: 0)
        }
    }
}

/// Music Library wrapper to make it easy for the rest of the classes to request music items
class DataStore: DataStoreProtocol {
    private var cache = MediaLibraryCache()
  
    private var lastArtist:            String?
    private var lastSongByArsitsAlbum: (String, String)?
    private var lastSongByPlaylist:    String?
    
    let playlistSemaphore = DispatchSemaphore(value: 1)
    let artistSemaphore   = DispatchSemaphore(value: 1)
    let albumSemaphore    = DispatchSemaphore(value: 1)
    let songSemaphore     = DispatchSemaphore(value: 1)
    
    private var _isDataLoaded: Bool = false
    
    func isDataLoaded() -> Bool { return _isDataLoaded }
    
    let datastoreQueue = DispatchQueue(label: "datastore")
    
    // Default size for artwork items
    let size = 250.0

    init() {
        fillCache()
    }
}

// MARK: RefreshList methods
extension DataStore {
    func fillCache() {
      
        // Fill playlist cache
        self.playlistSemaphore.wait()
        datastoreQueue.async {
            self.cache.playlistList = []
            
            self.cache.playlistList = PDMMediaLibrary.getPlaylistList().map {

                let name = $0.value(forProperty: MPMediaPlaylistPropertyName) as! String
                
                let playlist = MTPlaylistData(image: $0.representativeItem?.artwork == nil ? nil : ($0.representativeItem?.artwork?.image(at: CGSize(width: self.size, height: self.size)))!,
                                              name: name)
                
                playlist.songs = PDMMediaLibrary.getSongsList(byPlaylist: name).map {
                    MTSongData(mediaItem: $0)
                }.sorted {
                    if $0.mediaItem.albumTitle! == $1.mediaItem.albumTitle! {
                        return $0.mediaItem.albumTrackNumber < $1.mediaItem.albumTrackNumber
                    } else {
                        return $0.mediaItem.albumTitle! < $1.mediaItem.albumTitle!
                    }
                }
                
                return playlist
            }
            
            self.playlistSemaphore.signal()
        }
            
        // Get all the artists, and their albums and albums' songs
        self.songSemaphore.wait()
        self.albumSemaphore.wait()
        self.artistSemaphore.wait()
        datastoreQueue.async {
            
            let allAlbums  = PDMMediaLibrary.getAlbumsList()
            let allSongs   = PDMMediaLibrary.getSongsList()
            
            self.cache.artistList = PDMMediaLibrary.getAlbumArtistList().map {
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
            }.sorted {
                return $0.name < $1.name
            }
            
            self.artistSemaphore.signal()
          
            // Cache all the albums
            self.cache.albumList = self.cache.artistList.flatMap { $0.albums }
            self.albumSemaphore.signal()
          
            // Cache all the songs
            self.cache.songList = self.cache.albumList.flatMap { $0.songs }
            self.songSemaphore.signal()
        }

        // In a third background process, wait until the other two are completed to set the 'isDataLoaded' flag to true
        datastoreQueue.async {
            self.playlistSemaphore.wait()
            self.artistSemaphore.wait()
            self.albumSemaphore.wait()
            self.songSemaphore.wait()

            self._isDataLoaded = true

            self.songSemaphore.signal()
            self.albumSemaphore.signal()
            self.artistSemaphore.signal()
            self.playlistSemaphore.signal()
        }
    }
}

// MARK: return list
extension DataStore {
    
    /// Returns the songs list stored in the data-store object
    ///
    /// - Returns: songs list
    func songList() -> [MTSongData] {
        songSemaphore.wait()
        songSemaphore.signal()
        return cache.songList

    }
    
    /// Returns the albums list stored in the data-store object
    ///
    /// - Returns: albums list
    func albumList() -> [MTAlbumData] {
        albumSemaphore.wait()
        albumSemaphore.signal()
        return cache.albumList
    }

    /// Returns the playlists list stored in the data-store object
    ///
    /// - Returns: playlists list
    func playlistList() -> [MTPlaylistData] {
        playlistSemaphore.wait()
        playlistSemaphore.signal()
        return cache.playlistList
    }
    
    /// Returns the artists list stored in the data-store object
    ///
    /// - Returns: artists list
    func artistList() -> [MTArtistData] {
        artistSemaphore.wait()
        artistSemaphore.signal()
        return cache.artistList
    }

}

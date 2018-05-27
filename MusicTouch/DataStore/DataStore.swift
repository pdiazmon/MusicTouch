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

/// Music Library wrapper to make it easy for the rest of the classes to request music items
class DataStore {
    private var _artistList:           [Artist]
    private var _playlistList:         [Playlist]
    private var _albumList:            [Album]
    private var _songList:             MPMediaItemCollection?
    private var lastArtist:            String?
    private var lastSongByArsitsAlbum: (String, String)?
    private var lastSongByPlaylist:    String?
    
    // Default size for artwork items
    let size = 250.0

    init() {
        _artistList   = []
        _playlistList = []
        _albumList    = []
    }
}

// MARK: RefreshList methods
extension DataStore {
    
    /// Reads the artists from the music library and store them in the data-store artist list
    func refreshArtistList() {
        // We do not expect the music library changes during the app execution. So, if the data-store artist list is already filled, do nothing
        guard (_artistList.count == 0) else { return }
        
        for item in PDMMediaLibrary.getAlbumArtistList() {
            _artistList.append(Artist(artist: item.albumArtist!,
                                      image: item.artwork == nil ? nil : (item.artwork?.image(at: CGSize(width: self.size, height: self.size)))!))
        }
    }
    
    /// Reads the playlists from the music library and store them in the data-store playlist list
    func refreshPlaylistList() {
        // We do not expect the music library changes during the app execution. So, if the data-store playlist list is already filled, do nothing
        guard (_playlistList.count == 0) else { return }
        
        for item in PDMMediaLibrary.getPlaylistList() {
            _playlistList.append(Playlist(title: item.value(forProperty: MPMediaPlaylistPropertyName) as! String,
                                          image: item.representativeItem?.artwork == nil ? nil : (item.representativeItem?.artwork?.image(at: CGSize(width: self.size, height: self.size)))!))
        }
    }
    
    /// Refresh the albums from the music library, filtering by artist name, and store them in the data-store album list
    ///
    /// - Parameter byArtist: artist name
    func refreshAlbumList(byArtist: String) {
        
        // If the album list refresh requested is the same as the last time, we don't need to do it again
        guard (lastArtist == nil || lastArtist! != byArtist) else { return }
        
        _albumList = []
        lastArtist = byArtist
        
        for item in PDMMediaLibrary.getAlbumsList(byArtist: byArtist) {
            _albumList.append(Album(artist: item.artist!,
                                    album: item.albumTitle!,
                                    image: item.artwork == nil ? nil : (item.artwork?.image(at: CGSize(width: self.size, height: self.size)))!))
        }
    }
    
    /// Refresh the songs from the music library, filtering by artist name and album title, and store them in the data-store song list
    ///
    /// - Parameters:
    ///   - byArtist: artist name
    ///   - byAlbum: album title
    func refreshSongList(byArtist: String, byAlbum: String = "") {

        // If the song list refresh requested is the same as the last time, we don't need to do it again
        guard (lastSongByArsitsAlbum == nil || lastSongByArsitsAlbum! != (byArtist, byAlbum)) else { return }
        
        lastSongByArsitsAlbum = (byArtist, byAlbum)
        
        if let list = PDMMediaLibrary.getSongsList(byArtist: byArtist, byAlbum: byAlbum) {
            _songList = MPMediaItemCollection(items: list)
        }
    }
    
    /// Refresh the songs from the music library, filtering by playlist name, and store them in the data-store song list
    ///
    /// - Parameter byPlaylist: playlist name
    func refreshSongList(byPlaylist: String) {
        
        // If the song list refresh requested is the same as the last time, we don't need to do it again
        guard (lastSongByPlaylist == nil || lastSongByPlaylist! != byPlaylist) else { return }
        
        lastSongByPlaylist = byPlaylist
        
        if let list = PDMMediaLibrary.getSongsList(byPlaylist: byPlaylist) {
            _songList = MPMediaItemCollection(items: list)
        }
    }
    
    /// Refresh the songs list from the current album list
    func refreshSongListFromAlbumList() {
        var list: [MPMediaItem] = []
        
        // For all the current albums lists, get all their songs
        for album in _albumList {
            if let songlist = PDMMediaLibrary.getSongsList(byArtist: album.artist, byAlbum: album.album) {
                list = list + songlist
            }
        }
        _songList = MPMediaItemCollection(items: list)
    }

}

// MARK: return list
extension DataStore {
    
    /// Returns the songs list stored in the data-store object
    ///
    /// - Returns: songs list
    func songList() -> MPMediaItemCollection {
        if let list = _songList {
            return list
        }
        else {
            return MPMediaItemCollection(items: [])
        }
    }
    
    /// Returns the albums list stored in the data-store object
    ///
    /// - Returns: albums list
    func albumList() -> [Album] {
        return _albumList
    }

    /// Returns the playlists list stored in the data-store object
    ///
    /// - Returns: playlists list
    func playlistList() -> [Playlist] {
        return _playlistList
    }
    
    /// Returns the artists list stored in the data-store object
    ///
    /// - Returns: artists list
    func artistList() -> [Artist] {
        return _artistList
    }

}

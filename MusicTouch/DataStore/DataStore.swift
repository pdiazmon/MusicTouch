//
//  DataStore.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 24/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer
import PDMUtils_iOS

class DataStore {
    private var _artistList: [Artist]
    private var _playlistList: [Playlist]
    private var _albumList: [Album]
    private var _songList: MPMediaItemCollection?
    
    let size = 250.0

    init() {
        _artistList   = []
        _playlistList = []
        _albumList    = []
    }
}

// MARK: RefresList
extension DataStore {
    
    func refreshArtistList() {
        for item in PDMMediaLibrary.getAlbumArtistList() {
            _artistList.append(Artist(artist: item.albumArtist!,
                                     image: item.artwork == nil ? nil : (item.artwork?.image(at: CGSize(width: self.size, height: self.size)))!))
        }
    }
    
    func refreshPlaylistList() {
        for item in PDMMediaLibrary.getPlaylistList() {
            _playlistList.append(Playlist(title: item.value(forProperty: MPMediaPlaylistPropertyName) as! String,
                                         image: item.representativeItem?.artwork == nil ? nil : (item.representativeItem?.artwork?.image(at: CGSize(width: self.size, height: self.size)))!))
        }
    }
    
    func refreshAlbumList(byArtist: String) {
        _albumList = []
        for item in PDMMediaLibrary.getAlbumsList(byArtist: byArtist) {
            _albumList.append(Album(artist: item.artist!,
                                   album: item.albumTitle!,
                                   image: item.artwork == nil ? nil : (item.artwork?.image(at: CGSize(width: self.size, height: self.size)))!))
        }
    }
    
    func refreshSongList(byArtist: String, byAlbum: String = "") {
        if let list = PDMMediaLibrary.getSongsList(byArtist: byArtist, byAlbum: byAlbum) {
            _songList = MPMediaItemCollection(items: list)
        }
    }
    
    func refreshSongList(byPlaylist: String) {
        if let list = PDMMediaLibrary.getSongsList(byPlaylist: byPlaylist) {
            _songList = MPMediaItemCollection(items: list)
        }
    }
    
    // Refresh the songs list from the current album list
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
    
    func songList() -> MPMediaItemCollection? {
        return _songList
    }
    
    func albumList() -> [Album] {
        return _albumList
    }

    func playlistList() -> [Playlist] {
        return _playlistList
    }
    
    func artistList() -> [Artist] {
        return _artistList
    }

}

// MARK: addItem
extension DataStore {
    
    func addItem(_ newItem: Playlist) {
        _playlistList.append(newItem)
    }
    
    func addItem(_ newItem: Album) {
        _albumList.append(newItem)
    }
    
    func addItem(_ newItem: Artist) {
        _artistList.append(newItem)
    }

}

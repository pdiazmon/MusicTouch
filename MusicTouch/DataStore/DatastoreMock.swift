//
//  DatastoreMock.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 11/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer


class MPMediaItemMock: MPMediaItem {
    
    public var artistID: Int = 0
    public var albumID: Int = 0
    public var titleID: Int = 0
    
    init(artistID: Int, albumID: Int, titleID: Int) {
        super.init()
        
        self.artistID = artistID
        self.albumID  = albumID
        self.titleID  = titleID
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var albumArtist: String { return "Mock Artist \(artistID)" }
    override var albumTitle: String { return "Mock Album \(artistID)-\(albumID)" }
    override var title: String { return "Mock Song \(artistID)-\(albumID)-\(titleID)" }
    override var artwork: MPMediaItemArtwork? { return nil }
}

class MediaDB {
    public var _artistList:           [Artist] = []
    public var _playlistList:         [Playlist] = []
    public var _albumList:            [Album] = []
    public var _songList =             MPMediaItemCollection(items: [])

    init() {
        self.initializePlaylistList()
        self.initializeArtistList()
        self.initializeAlbumsList()
        self.initializeSongsList()
    }
    
    func initializePlaylistList() {
        let playlist1 = Playlist(title: "Mock Playlist 1", image: nil)
        let playlist2 = Playlist(title: "Mock Playlist 2", image: nil)
        
        _playlistList = [playlist1, playlist2]
    }
    
    func initializeArtistList() {
        let artist1 = Artist(artist: "Mock Artist 1", image: nil)
        let artist2 = Artist(artist: "Mock Artist 2", image: nil)
        
        _artistList = [artist1, artist2]
    }
    
    func initializeAlbumsList() {
        let album11 = Album(artist: "Mock Artist 1", album: "Mock Album 1-1", image: nil)
        let album12 = Album(artist: "Mock Artist 1", album: "Mock Album 1-2", image: nil)
        let album21 = Album(artist: "Mock Artist 2", album: "Mock Album 2-1", image: nil)
        
        _albumList = [album11, album12, album21]
    }
    
    func initializeSongsList() {
        let song111 = MPMediaItemMock(artistID: 1, albumID: 1, titleID: 1)
        let song112 = MPMediaItemMock(artistID: 1, albumID: 1, titleID: 2)
        let song113 = MPMediaItemMock(artistID: 1, albumID: 1, titleID: 3)
        let song121 = MPMediaItemMock(artistID: 1, albumID: 2, titleID: 1)
        let song122 = MPMediaItemMock(artistID: 1, albumID: 2, titleID: 2)
        let song211 = MPMediaItemMock(artistID: 2, albumID: 1, titleID: 1)
        
        _songList = MPMediaItemCollection(items: [song111, song112, song113, song121, song122, song211])
    }

}

class DataStoreMock: DataStoreProtocol {
    
    private var _artistList:           [Artist] = []
    private var _playlistList:         [Playlist] = []
    private var _albumList:            [Album] = []
    private var _songList =             MPMediaItemCollection(items: [])

    private var _mediaDB = MediaDB()
    
    func refreshArtistList() {
        _artistList = _mediaDB._artistList
    }
    
    func refreshPlaylistList() {
        _playlistList = _mediaDB._playlistList
    }
    
    func refreshAlbumList(byArtist: String) {
        if (byArtist.count > 0) {
            _albumList = _mediaDB._albumList.filter { $0.artist == byArtist }
        }
        else {
            _albumList = _mediaDB._albumList
        }
    }
    
    func refreshSongList(byArtist: String, byAlbum: String) {
        if (byArtist.count == 0 && byAlbum.count == 0) {
            _songList = _mediaDB._songList
        }
        else if (byAlbum.count > 0) {
            _songList = MPMediaItemCollection(items: _mediaDB._songList.items.filter { $0.albumArtist == byArtist && $0.albumTitle == byAlbum })
        }
        else {
            _songList = MPMediaItemCollection(items: _mediaDB._songList.items.filter { $0.albumArtist == byArtist })
        }
    }
    
    func refreshSongList(byPlaylist: String) {
        _songList = MPMediaItemCollection(items: [_mediaDB._songList.items[0], _mediaDB._songList.items[1]])
    }

//    func refreshSongList(byArtist: String) {
//        refreshSongList(byArtist: byArtist, byAlbum: "")
//    }
    
    func refreshSongListFromAlbumList() {
        _songList = _mediaDB._songList
    }
    
    func songList() -> MPMediaItemCollection {
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

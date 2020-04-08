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
    
    public var _artist: String!
    public var _album: String!
    public var _title: String!
    
    init(artist: String, album: String, title: String) {
        super.init()
        
        self._artist = artist
        self._album  = album
        self._title  = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var albumArtist: String { return _artist }
    override var albumTitle: String { return _album }
    override var title: String { return _title }
    override var artwork: MPMediaItemArtwork? { return nil }
}

class MediaDB {
    public var _artistList:           [MTArtistData] = []
    public var _playlistList:         [MTPlaylistData] = []
    public var _albumList:            [MTAlbumData] = []
    public var _songList:             [MTSongData] = []

    init() {}

}

class DataStoreMock: DataStoreProtocol {
    
    private var _artistList:           [MTArtistData] = []
    private var _playlistList:         [MTPlaylistData] = []
    private var _albumList:            [MTAlbumData] = []
    private var _songList:             [MTSongData] = [] 

    private var _mediaDB = MediaDB()
    
    func refreshArtistList() {
        _artistList = _mediaDB._artistList
    }
    
    func refreshPlaylistList() {
        _playlistList = _mediaDB._playlistList
    }
    
    func refreshAlbumList(byArtist: String) {
        if (byArtist.count > 0) {
            _albumList = _mediaDB._albumList.filter { $0.artistName == byArtist }
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
            _songList = _mediaDB._songList.filter { $0.mediaItem!.albumArtist == byArtist && $0.mediaItem!.albumTitle == byAlbum }
        }
        else {
            _songList = _mediaDB._songList.filter { $0.mediaItem!.albumArtist == byArtist }
        }
    }
    
    func refreshSongList(byPlaylist: String) {
        _songList = [_mediaDB._songList[0], _mediaDB._songList[1]]
    }

    func refreshSongListFromAlbumList() {
        _songList = _mediaDB._songList
    }
    
    func songList() -> [MTSongData] {
        return _songList
    }
    
    func songCollection() -> MPMediaItemCollection {
        return MPMediaItemCollection(items: [])
    }
    
    func albumList() -> [MTAlbumData] {
        return _albumList
    }
    
    func playlistList() -> [MTPlaylistData] {
        return _playlistList
    }
    
    func artistList() -> [MTArtistData] {
        return _artistList
    }
    
    func isDataLoaded() -> Bool {
        return true
    }
    
}

extension DataStoreMock {
    func newPlaylist(playlist: String) {
        _mediaDB._playlistList.append(MTPlaylistData(image: nil, name: playlist))
    }
    
    func newArtist(artist: String) {
        _mediaDB._artistList.append(MTArtistData(image: nil, name: artist))
    }
    
    func newAlbum(artist: String, album: String) {
        _mediaDB._albumList.append(MTAlbumData(image: nil, artistName: artist, albumTitle: album, year: 2018))
    }
    
    func newSong(artist: String, album: String, title: String) {
        _mediaDB._songList = _mediaDB._songList + [MTSongData(mediaItem: MPMediaItemMock(artist: artist, album: album, title: title))]
    }
}

extension DataStoreMock {
    public func defaultInitialize() {
        
        newPlaylist(playlist: "Mock Playlist 1")
        newPlaylist(playlist: "Mock Playlist 2")
        
        newArtist(artist: "Mock Artist 1")
        newArtist(artist: "Mock Artist 2")

        newAlbum(artist: "Mock Artist 1", album: "Mock Album 1-1")
        newAlbum(artist: "Mock Artist 1", album: "Mock Album 1-2")
        newAlbum(artist: "Mock Artist 2", album: "Mock Album 2-1")

        newSong(artist: "Mock Artist 1", album: "Mock Album 1-1", title: "Mock Song 1-1-1")
        newSong(artist: "Mock Artist 1", album: "Mock Album 1-1", title: "Mock Song 1-1-2")
        newSong(artist: "Mock Artist 1", album: "Mock Album 1-1", title: "Mock Song 1-1-3")
        newSong(artist: "Mock Artist 1", album: "Mock Album 1-2", title: "Mock Song 1-2-1")
        newSong(artist: "Mock Artist 1", album: "Mock Album 1-2", title: "Mock Song 1-1-2")
        newSong(artist: "Mock Artist 2", album: "Mock Album 2-1", title: "Mock Song 2-1-1")

    }
}

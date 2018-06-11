//
//  Datastore.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 11/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

protocol DataStoreProtocol {
    
    func refreshArtistList()
    
    func refreshPlaylistList()
    
    func refreshAlbumList(byArtist: String)
    
    func refreshSongList(byArtist: String, byAlbum: String)
    
    func refreshSongList(byPlaylist: String)
    
    func refreshSongListFromAlbumList()
    
    func songList() -> MPMediaItemCollection
    
    func albumList() -> [Album]
    
    func playlistList() -> [Playlist]
    
    func artistList() -> [Artist]
}

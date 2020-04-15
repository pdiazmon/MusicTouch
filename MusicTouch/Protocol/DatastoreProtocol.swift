//
//  Datastore.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 11/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
// import MediaPlayer

protocol DataStoreProtocol: MediaLibraryProtocol {
	
	func fillCache()
    
    func songList() -> [MTSongData]
    
    func albumList() -> [MTAlbumData]
    
    func playlistList() -> [MTPlaylistData]
    
    func artistList() -> [MTArtistData]
    
    func isDataLoaded() -> Bool
	
	func add(playlist: MTPlaylistData)
	
	func add(artist: MTArtistData)
	
}

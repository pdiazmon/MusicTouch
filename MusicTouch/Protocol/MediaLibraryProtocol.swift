//
//  MediaLibraryProtocol.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 11/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

protocol MediaLibraryProtocol {

	// Get MPMediaItem
	func getPlaylistItem(byPlaylistName: String?) -> MPMediaItem?

	func getSongItem(byPersistentID: MPMediaEntityPersistentID) -> MPMediaItem?
	
	// Get Collections of items
	func getPlaylistList() -> [MPMediaItemCollection]
	
	func getAlbumList() -> [MPMediaItem]
	
	func getAlbumArtistList() -> [MPMediaItem]

	func getAlbumsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem]

	// Get songs
	func getSongsList() -> [MPMediaItem]
	
	func getSongsList(byPlaylist: String) -> [MPMediaItem]

	func getSongsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem]

	func getSongsList(byAlbumPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem]

	// Get Artwork images
	func getAlbumArtworkImage(byAlbumPersistentID: MPMediaEntityPersistentID) -> UIImage?
	
	func getSongArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage?
	
	func getArtistArtworkImage(byArtistPersistentID: MPMediaEntityPersistentID) -> UIImage?	
	
	func getPlaylistArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage?
}

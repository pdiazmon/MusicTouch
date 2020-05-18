//
//  DataStore.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 24/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

/// Music Library wrapper to make it easy for the rest of the classes to request music items
class DataStore: DataStoreProtocol {
  
    private var lastArtist:            String?
    private var lastSongByArsitsAlbum: (String, String)?
    private var lastSongByPlaylist:    String?
    
    private var _isDataLoaded: Bool = true
    
    func isDataLoaded() -> Bool { return _isDataLoaded }
        
    // Default size for artwork items
    let size = 250.0
	
	var mediaLibrary: MediaLibraryProtocol

	init(mediaLibrary: MediaLibraryProtocol) {
		self.mediaLibrary = mediaLibrary
    }
}

// MARK: return list
extension DataStore {
    
    /// Returns the songs list stored in the data-store object
    ///
    /// - Returns: songs list
    func songList() -> [MTSongData] {
		return self.mediaLibrary.getSongsList().map {
			return MTSongData(mediaItem: $0, mediaLibrary: self.mediaLibrary)
		}
    }
    
    /// Returns the albums list stored in the data-store object
    ///
    /// - Returns: albums list
    func albumList() -> [MTAlbumData] {
		return self.mediaLibrary.getAlbumList().map {
			return MTAlbumData(persistentID: $0.albumPersistentID,
							   artistName: $0.albumArtist ?? "",
							   albumTitle: $0.albumTitle ?? "",
							   mediaLibrary: self.mediaLibrary)
		}
    }

    /// Returns the playlists list stored in the data-store object
    ///
    /// - Returns: playlists list
    func playlistList() -> [MTPlaylistData] {
		return self.mediaLibrary.getPlaylistList().map {
			let name = $0.value(forProperty: MPMediaPlaylistPropertyName) as! String
			let persistentID = self.mediaLibrary.getPlaylistItem(byPlaylistName: name)?.persistentID
			
			return MTPlaylistData(persistentID: persistentID, name: name, mediaLibrary: self.mediaLibrary)
		}
    }
    
    /// Returns the artists list stored in the data-store object
    ///
    /// - Returns: artists list
    func artistList() -> [MTArtistData] {
		return self.mediaLibrary.getAlbumArtistList().map {
			return MTArtistData(persistentID: $0.albumArtistPersistentID, name: $0.albumArtist ?? "", mediaLibrary: self.mediaLibrary)
		}
    }

}

extension DataStore {
	
	/// Gets the list of playlists ready to provide them to the player
	/// - Returns: the playlists list
	func getPlaylistList() -> [MPMediaItemCollection] { return mediaLibrary.getPlaylistList() }
	
	/// Gets the list of albums ready to provide them to the player
	/// - Returns: the albums list
	func getAlbumList() -> [MPMediaItem] { return mediaLibrary.getAlbumList() }
	
	/// Gets the list of artists ready to provide them to the player
	/// - Returns: the artists list
	func getAlbumArtistList() -> [MPMediaItem] { return mediaLibrary.getAlbumArtistList() }
	
	/// Gets the list of songs ready to provide them to the player
	/// - Returns: the songs list
	func getSongsList() -> [MPMediaItem] { return mediaLibrary.getSongsList() }

	/// Gets an specific playlist from the Media Library by its name ready
	/// - Parameter byPlaylistName: the playlist name
	/// - Returns: the playlist media item
	func getPlaylistItem(byPlaylistName: String?) -> MPMediaItem? { return mediaLibrary.getPlaylistItem(byPlaylistName: byPlaylistName) }
	
	/// Gets an specific album from the Media Library by its persistent Id
	/// - Parameter byAlbumPersistentID: album persistent Id
	/// - Returns: album media item
	func getSongsList(byAlbumPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] { return mediaLibrary.getSongsList(byAlbumPersistentID: byAlbumPersistentID) }
	
	/// Gets an specific album's artwork image from the Media Library by its persistent Id
	/// - Parameter byAlbumPersistentID: album persistent Id
	/// - Returns: album's artwork image
	func getAlbumArtworkImage(byAlbumPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getAlbumArtworkImage(byAlbumPersistentID: byAlbumPersistentID) }
	
	/// Gets an specific song from the Media Library by its persistent Id
	/// - Parameter byPersistentID: song persistent Id
	/// - Returns: song media item
	func getSongItem(byPersistentID: MPMediaEntityPersistentID) -> MPMediaItem? { return mediaLibrary.getSongItem(byPersistentID: byPersistentID) }
	
	/// Gets an specific song's artwork image from the Media Library by its persistent Id
	/// - Parameter byPersistentID: song persistent Id
	/// - Returns: song's artwork image
	func getSongArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getSongArtworkImage(byPersistentID: byPersistentID) }
	
	/// Gets the album list from the Media Library by the artist persistent Id
	/// - Parameter byArtistPersistentID: artist persistent ID
	/// - Returns: list of artist's albums
	func getAlbumsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] { return mediaLibrary.getAlbumsList(byArtistPersistentID: byArtistPersistentID) }
	
	/// Gets an specific artist's artwork image from the Media Library by its persistent Id
	/// - Parameter byArtistPersistentID: artist's persistent Id
	/// - Returns: artist's artwork image
	func getArtistArtworkImage(byArtistPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getArtistArtworkImage(byArtistPersistentID: byArtistPersistentID) }
	
	/// Gets the song list from the Media Library by the artist persistent Id
	/// - Parameter byArtistPersistentID: artist persistent Id
	/// - Returns: list of artist's songs
	func getSongsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] { return mediaLibrary.getSongsList(byArtistPersistentID: byArtistPersistentID) }
	
	/// Gets the song list from the Media Library by the playlist title
	/// - Parameter byPlaylist: playlist title
	/// - Returns: playlist songs list
	func getSongsList(byPlaylist: String) -> [MPMediaItem] { return mediaLibrary.getSongsList(byPlaylist: byPlaylist) }
	
	/// Gets an specific playlist's artwork image from the Media Library by its persistent Id
	/// - Parameter byPersistentID: playlist persistent Id
	/// - Returns: playlist's artwork image
	func getPlaylistArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getPlaylistArtworkImage(byPersistentID: byPersistentID) }
	
}

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
	
	func getPlaylistList() -> [MPMediaItemCollection] { return mediaLibrary.getPlaylistList() }
	
	func getAlbumList() -> [MPMediaItem] { return mediaLibrary.getAlbumList() }
	
	func getAlbumArtistList() -> [MPMediaItem] { return mediaLibrary.getAlbumArtistList() }
	
	func getSongsList() -> [MPMediaItem] { return mediaLibrary.getSongsList() }

	func getPlaylistItem(byPlaylistName: String?) -> MPMediaItem? { return mediaLibrary.getPlaylistItem(byPlaylistName: byPlaylistName) }
	
	func getSongsList(byAlbumPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] { return mediaLibrary.getSongsList(byAlbumPersistentID: byAlbumPersistentID) }
	
	func getAlbumArtworkImage(byAlbumPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getAlbumArtworkImage(byAlbumPersistentID: byAlbumPersistentID) }
	
	func getSongItem(byPersistentID: MPMediaEntityPersistentID) -> MPMediaItem? { return mediaLibrary.getSongItem(byPersistentID: byPersistentID) }
	
	func getSongArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getSongArtworkImage(byPersistentID: byPersistentID) }
	
	func getAlbumsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] { return mediaLibrary.getAlbumsList(byArtistPersistentID: byArtistPersistentID) }
	
	func getArtistArtworkImage(byArtistPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getArtistArtworkImage(byArtistPersistentID: byArtistPersistentID) }
	
	func getSongsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] { return mediaLibrary.getSongsList(byArtistPersistentID: byArtistPersistentID) }
	
	func getSongsList(byPlaylist: String) -> [MPMediaItem] { return mediaLibrary.getSongsList(byPlaylist: byPlaylist) }
	
	func getPlaylistArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage? { return mediaLibrary.getPlaylistArtworkImage(byPersistentID: byPersistentID) }
	
}

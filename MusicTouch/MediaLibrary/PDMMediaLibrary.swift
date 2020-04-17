//
//  PDMMediaLibrary.swift
//  PDMUtils
//
//  Created by Pedro L. Diaz Montilla on 12/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

public class PDMMediaLibrary: MediaLibraryProtocol {
    
    public init() {}
    
    /// As every query to the Media Library must previously check the application authorization, it should be performed within this function to avoid repeating code
    private func perform(_ block: @escaping () -> Void) {
        
        switch (MPMediaLibrary.authorizationStatus()) {
            
        case MPMediaLibraryAuthorizationStatus.authorized:
            block()
            
        case MPMediaLibraryAuthorizationStatus.notDetermined:
            MPMediaLibrary.requestAuthorization( { (status) in
                switch status {
                case .authorized:
                    block()
                default:
                    break
                }
            })
 
        default:
            break
        }
    }
	
    /// Returns all the albums in the Media Library
    /// - Returns: A MPMediaItem array with all the albumss in the Media Library. Every MPMediaItem in the array is the album representative item.
    public func getAlbumList() -> [MPMediaItem] {
        var list: [MPMediaItem] = []
        
        perform() {
            // Query for all the songs in the Media Library
			let query = MPMediaQuery.albums()
            
            // Group the query results in different collections by album artist name
			query.groupingType = MPMediaGrouping.album
            
            // Get all the collections returned by the query and add their representative item to a list
            if let result = query.collections {
                for res in result {
                    list.append((res.representativeItem)!)
                }
            }
        }
        
        // Sort the list by album artist name and return it
		return list.sorted { $0.albumTitle! < $1.albumTitle! }
    }

    
    /// Returns all the album artists in the Media Library
    /// - Returns: A MPMediaItem array with all the album artists in the Media Library. Every MPMediaItem in the array is the album artist representative item.
    public func getAlbumArtistList() -> [MPMediaItem] {
        var list: [MPMediaItem] = []
        
        perform() {
            // Query for all the songs in the Media Library
            let query = MPMediaQuery.songs()
            
            // Group the query results in different collections by album artist name
            query.groupingType = MPMediaGrouping.albumArtist
            
            // Get all the collections returned by the query and add their representative item to a list
            if let result = query.collections {
                for res in result {
                    list.append((res.representativeItem)!)
                }
            }
        }
        
        // Sort the list by album artist name and return it
        return list.sorted { $0.albumArtist! < $1.albumArtist! }
    }

    /// Returns all the albums for a given album artist in the Media Library
    /// - Parameters:
    ///   - byArtistPersistentID: Artist persistent ID
    /// - Returns: A MPMediaItem array with all the albums for a given album artist
	public func getAlbumsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] {
        var list: [MPMediaItem] = []
        
        perform() {
            
            var query: MPMediaQuery
            
			// Set the filter query for the given artist persistent ID
			let artistFilter = MPMediaPropertyPredicate(value: byArtistPersistentID, forProperty: MPMediaItemPropertyAlbumArtistPersistentID, comparisonType: MPMediaPredicateComparison.equalTo)
			let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter]
			query = MPMediaQuery(filterPredicates: myFilterSet)
            
            // Group the query results in different collections by album title
            query.groupingType = MPMediaGrouping.album
            
            // Get all the collections returned by the query and add their representative item to a list
            if let result = query.collections {
                for res in result {
                    list.append((res.representativeItem)!)
                }
            }
        }
        
        // Sort the list by album title and return it
        return list.sorted { $0.albumTitle! < $1.albumTitle! }
    }

    /// Converts playtime in seconds to hours, minutes and seconds
    /// - Parameters:
    ///   - seconds: Playlist in seconds
    /// - Returns: Playtime in hours, minutes and seconds
    private func playTimeFrom(seconds: Int) -> (hours: Int, minutes: Int, senconds: Int) {
        let _hour = Int(seconds / 3600)
        let rem = seconds % 3600
        let _min = Int(rem / 60)
        let _sec = rem % 60
        
        return (_hour, _min, _sec)
    }
  
    /// Returns all the songs in a given playlist
    /// - Parameters:
    ///   - byPlaylist: Playlist name
    /// - Returns: A MPMediaItem array with all the songs in the given playlist
    public func getSongsList(byPlaylist: String) -> [MPMediaItem] {
        
		// Set the filter for the playlist name
		let playlistFilter = MPMediaPropertyPredicate(value: byPlaylist, forProperty: MPMediaPlaylistPropertyName)
		let songFilter = MPMediaPropertyPredicate(value: MPMediaType.music.rawValue,
                                                      forProperty: MPMediaItemPropertyMediaType,
                                                      comparisonType: MPMediaPredicateComparison.equalTo)
		let myFilterSet: Set<MPMediaPropertyPredicate> = [playlistFilter, songFilter]
            
		return getSongList(byFilterSet: myFilterSet)
    }
    
	public func getSongsList(byAlbumPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] {
		// Set the filter
		let albumFilter = MPMediaPropertyPredicate(value: byAlbumPersistentID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)

		return getSongList(byFilter: albumFilter)
	}

	public func getSongsList(byArtistPersistentID: MPMediaEntityPersistentID) -> [MPMediaItem] {
		// Set the filter
		let artistFilter = MPMediaPropertyPredicate(value: byArtistPersistentID, forProperty: MPMediaItemPropertyAlbumArtistPersistentID, comparisonType: .equalTo)

		return getSongList(byFilter: artistFilter)
	}
	
	private func getSongList(byFilter: MPMediaPropertyPredicate) -> [MPMediaItem] {
		// Set the filter
		let myFilterSet: Set<MPMediaPropertyPredicate> = [byFilter]
		
		return getSongList(byFilterSet: myFilterSet)
	}

	private func getSongList(byFilterSet: Set<MPMediaPropertyPredicate>) -> [MPMediaItem] {
		var query: MPMediaQuery?
        
        perform() {
            // Perform the query
            query = MPMediaQuery(filterPredicates: byFilterSet)
        }
        
        if let resultQ = query, let resultI = resultQ.items {
			return resultI.sorted {
				if ($0.albumArtist! == $1.albumArtist!) {
					if ($0.albumTitle! == $1.albumTitle!) { return $0.albumTrackNumber < $1.albumTrackNumber }
					else { return $0.albumTitle! < $1.albumTitle! }
				}
				else { return  $0.albumArtist! < $1.albumArtist! }
			}
        }
        else {
            return []
        }
	}
	
    /// Returns all the songs in the Media Library
    /// - Returns: A MPMediaItem array with all the songs
    public func getSongsList() -> [MPMediaItem] {
		let songFilter = MPMediaPropertyPredicate(value: MPMediaType.music.rawValue,
		                                          forProperty: MPMediaItemPropertyMediaType,
		                                          comparisonType: MPMediaPredicateComparison.equalTo)
		return getSongList(byFilter: songFilter)
    }
	
    /// Returns all the created playlist in the Media Library
    /// - Returns: A MPMediaCollection array with all the playlists
    public func getPlaylistList() -> [MPMediaItemCollection] {
        
        var list: [MPMediaItemCollection] = []

        perform() {
            // Get all the playlists from the Media Library
            let query = MPMediaQuery.playlists()
            
            // Convert it to a MPMediaCollection array ...
            list.append(contentsOf: query.collections!)
        }
        
        // ... and return it
        return list
        
    }

    /// Returns an specific playlist's item
    /// - Returns: A MPMediaItem with the playlist
	public func getPlaylistItem(byPlaylistName: String?) -> MPMediaItem? {
		
		guard let playlistName = byPlaylistName else { return nil }
        
		var query: MPMediaQuery?
		
		// Set a filter by the playlist name
		let playlistFilter = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaPlaylistPropertyName, comparisonType: MPMediaPredicateComparison.equalTo)

		let myFilterSet: Set<MPMediaPropertyPredicate> = [playlistFilter]
	
		perform() {
			// Perform the query
			query = MPMediaQuery(filterPredicates: myFilterSet)
		}
			
		if let resultQ = query, let resultI = resultQ.items {
			return resultI.first
        }
        else {
            return nil
        }
    }

	public func getPlaylistItem(byPlaylistPersistentID: MPMediaEntityPersistentID) -> MPMediaItem? {
		let filter = MPMediaPropertyPredicate(value: byPlaylistPersistentID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: MPMediaPredicateComparison.equalTo)

		return getMediaItem(byFilter: filter)
    }

    /// Returns an specific artist's item
    /// - Returns: A MPMediaItem with the artist
	public func getArtistItem(byArtistPersistentID: MPMediaEntityPersistentID) -> MPMediaItem? {
		let filter = MPMediaPropertyPredicate(value: byArtistPersistentID, forProperty: MPMediaItemPropertyAlbumArtistPersistentID, comparisonType: MPMediaPredicateComparison.equalTo)

		return getMediaItem(byFilter: filter)
	}

    /// Returns an specific album's item
    /// - Returns: A MPMediaItem with the album
	public func getAlbumItem(byAlbumPersistentID: MPMediaEntityPersistentID) -> MPMediaItem? {
		let filter = MPMediaPropertyPredicate(value: byAlbumPersistentID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: MPMediaPredicateComparison.equalTo)

		return getMediaItem(byFilter: filter)
    }

    /// Returns an specific song's item
    /// - Returns: A MPMediaItem with the song
	public func getSongItem(byPersistentID: MPMediaEntityPersistentID) -> MPMediaItem? {
		let filter = MPMediaPropertyPredicate(value: byPersistentID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: MPMediaPredicateComparison.equalTo)

		return getMediaItem(byFilter: filter)
    }
	
    /// Returns an specific media item
    /// - Returns: A MPMediaItem
	public func getMediaItem(byFilter: MPMediaPropertyPredicate) -> MPMediaItem? {
		
		var query: MPMediaQuery?
		
		let myFilterSet: Set<MPMediaPropertyPredicate> = [byFilter]
	
		perform() {
			// Perform the query
			query = MPMediaQuery(filterPredicates: myFilterSet)
		}
		
		if let resultQ = query, let resultI = resultQ.items {
			return resultI.first
        }
        else {
            return nil
        }
    }

    /// Returns an specific playlist's artwork
    /// - Returns: The playlist's MPMediaItemArtwork Image
	public func getPlaylistArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage? {
		
		guard let item = getPlaylistItem(byPlaylistPersistentID: byPersistentID) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }

    /// Returns an specific artist's artwork
    /// - Returns: The artist's MPMediaItemArtwork Image
	public func getArtistArtworkImage(byArtistPersistentID: MPMediaEntityPersistentID) -> UIImage? {
		
		guard let item = getArtistItem(byArtistPersistentID: byArtistPersistentID) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }

    /// Returns an specific album's artwork
    /// - Returns: The album's MPMediaItemArtwork Image
	public func getAlbumArtworkImage(byAlbumPersistentID: MPMediaEntityPersistentID) -> UIImage? {
		
		guard let item = getAlbumItem(byAlbumPersistentID: byAlbumPersistentID) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }

    /// Returns an specific song's artwork
    /// - Returns: The song's MPMediaItemArtwork Image
	public func getSongArtworkImage(byPersistentID: MPMediaEntityPersistentID) -> UIImage? {
		
		guard let item = getSongItem(byPersistentID: byPersistentID) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }


}

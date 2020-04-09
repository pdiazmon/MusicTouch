//
//  PDMMediaLibrary.swift
//  PDMUtils
//
//  Created by Pedro L. Diaz Montilla on 12/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

public class PDMMediaLibrary {
    
    public init() {}
    
    /// As every query to the Media Library must previously check the application authorization, it should be performed within this function to avoid repeating code
    class private func perform(_ block: @escaping () -> Void) {
        
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
    
    /// Returns all the artists in the Media Library
    /// - Returns: A MPMediaItem array with all the artists in the Media Library. Every MPMediaItem in the array is the artist representative item.
    class public func getArtistList() -> [MPMediaItem] {
        var list: [MPMediaItem] = []
        
        perform() {
            // Query for all the artists in the Media Library
            let query = MPMediaQuery.artists()
            
            // Group the query results in different collections by artist name
            query.groupingType = MPMediaGrouping.artist
            
            // Get all the collections returned by the query and add their representative item to a list
            if let result = query.collections {
                for res in result {
                    list.append((res.representativeItem)!)
                }
            }
        }
        
        // Sort the list by artist name and return it
        return list.sorted { $0.artist! < $1.artist! }
    }

    /// Returns all the album artists in the Media Library
    /// - Returns: A MPMediaItem array with all the album artists in the Media Library. Every MPMediaItem in the array is the album artist representative item.
    class public func getAlbumArtistList() -> [MPMediaItem] {
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
    ///   - byArtist: Artist name
    /// - Returns: A MPMediaItem array with all the albums for a given album artist
    class public func getAlbumsList(byArtist: String) -> [MPMediaItem] {
        var list: [MPMediaItem] = []
        
        perform() {
            
            var query: MPMediaQuery
            
            // If an artist is given ...
            if (byArtist.count > 0) {
                // Set the filter query for the given artist name
                let artistFilter = MPMediaPropertyPredicate(value: byArtist, forProperty: MPMediaItemPropertyAlbumArtist, comparisonType: MPMediaPredicateComparison.equalTo)
                let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter]
                query = MPMediaQuery(filterPredicates: myFilterSet)
            }
            else { // An empty artist name has been received, create an empty query
                query = MPMediaQuery()
            }
            
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

    /// Returns the playlist play time
    /// - Parameters:
    ///   - byPlaylist: Playlist name
    /// - Returns: Playlist playtime in hours, minutes and seconds
    class public func getPlayTime(byPlaylist: String) -> (hours: Int, minutes: Int, senconds: Int) {
        var seconds: Int = 0

        for song in getSongsList(byPlaylist: byPlaylist) {
            seconds += Int(song.playbackDuration)
        }
        
        return playTimeFrom(seconds: seconds)
    }
    
    /// Converts playtime in seconds to hours, minutes and seconds
    /// - Parameters:
    ///   - seconds: Playlist in seconds
    /// - Returns: Playtime in hours, minutes and seconds
    class private func playTimeFrom(seconds: Int) -> (hours: Int, minutes: Int, senconds: Int) {
        let _hour = Int(seconds / 3600)
        let rem = seconds % 3600
        let _min = Int(rem / 60)
        let _sec = rem % 60
        
        return (_hour, _min, _sec)
    }
  
    /// Returns the artist play time
    /// - Parameters:
    ///   - byArtist: Artist name
    /// - Returns: Artist playtime in hours, minutes and seconds
    class public func getPlayTime(byArtist: String) -> (hours: Int, minutes: Int, senconds: Int) {
        
        var seconds: Int = 0
        
        let list = getAlbumsList(byArtist: byArtist)
        
        for album in list {
            let (hour, min, sec) = getPlayTime(byArtist: album.albumArtist!, byAlbum: album.albumTitle!)
            seconds = seconds + hour * 3600 + min * 60 + sec
        }
        
        return playTimeFrom(seconds: seconds)
    }
    
    /// Returns the album play time
    /// - Parameters:
    ///   - byArtist: Artist name
    ///   - byAlbum: Album title
    /// - Returns: Album playtime in hours, minutes and seconds
    class public func getPlayTime(byArtist: String, byAlbum: String) -> (hours: Int, minutes: Int, senconds: Int) {
        var seconds: Int = 0
        
        for song in getSongsList(byArtist: byArtist, byAlbum: byAlbum) {
            seconds += Int(song.playbackDuration)
        }
        
        return playTimeFrom(seconds: seconds)
    }
    
    /// Returns all the albums in the Media Library
    /// - Returns: A MPMediaItem array with all the albums in the Media Library. Every MPMediaItem in the array is the album representative item.
    class public func getAlbumsList() -> [MPMediaItem] {
        
        // Perform the same query with an empty artist name to get all the albums in the Media Library
        return getAlbumsList(byArtist: "")
    }
    
    /// Returns a list with all the songs for a given artist and album
    /// - Parameters:
    ///   - byArtist: Artist name
    ///   - byAlbum: Album title
    /// - Returns: A MPMediaItem array with all the songs
    class public func getSongsList(byArtist: String, byAlbum: String = "") -> [MPMediaItem] {
        
        var query: MPMediaQuery?
        
        perform() {
            // If only an artist name is given, without an album title
            if (byArtist.count > 0 && byAlbum.count == 0) {
                // Only set a filter for the album artist name
                let artistFilter = MPMediaPropertyPredicate(value: byArtist, forProperty: MPMediaItemPropertyAlbumArtist, comparisonType: MPMediaPredicateComparison.equalTo)
                let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter]

                // Perform the query
                query = MPMediaQuery(filterPredicates: myFilterSet)
            }
            // If an artist name and an album title are given
            else if (byArtist.count > 0 && byAlbum.count > 0) {
                // Set a composed filter by the artist name and album filter
                let artistFilter = MPMediaPropertyPredicate(value: byArtist, forProperty: MPMediaItemPropertyAlbumArtist, comparisonType: MPMediaPredicateComparison.equalTo)
                let albumFilter  = MPMediaPropertyPredicate(value: byAlbum, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo)

                let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter, albumFilter]
            
                // Perform the query
                query = MPMediaQuery(filterPredicates: myFilterSet)
            }
            // In any other case
            else {
                // Set the filter to get all the songs in the MediaLibrary
                let songFilter = MPMediaPropertyPredicate(value: MPMediaType.music.rawValue,
                                                          forProperty: MPMediaItemPropertyMediaType,
                                                          comparisonType: MPMediaPredicateComparison.equalTo)
                let myFilterSet: Set<MPMediaPropertyPredicate> = [songFilter]
                
                // Perform the query
                query = MPMediaQuery(filterPredicates: myFilterSet)
            }
        }
        
        // Sort the collection by song title and return it
        if let resultQ = query, let resultI = resultQ.items {
            return resultI.sorted { $0.title! < $1.title! }
        }
        else {
            return []
        }
    }
    
    /// Returns all the songs in a given playlist
    /// - Parameters:
    ///   - byPlaylist: Playlist name
    /// - Returns: A MPMediaItem array with all the songs in the given playlist
    class public func getSongsList(byPlaylist: String) -> [MPMediaItem] {
        
        var query: MPMediaQuery?
        
        perform() {
            // Set the filter for the playlist name
            let playlistFilter = MPMediaPropertyPredicate(value: byPlaylist, forProperty: MPMediaPlaylistPropertyName)
            let songFilter = MPMediaPropertyPredicate(value: MPMediaType.music.rawValue,
                                                      forProperty: MPMediaItemPropertyMediaType,
                                                      comparisonType: MPMediaPredicateComparison.equalTo)
            let myFilterSet: Set<MPMediaPropertyPredicate> = [playlistFilter, songFilter]
            
            // Perform the query
            query = MPMediaQuery(filterPredicates: myFilterSet)
        }
        
        // Sort the collection by song title and return it
        if let resultQ = query, let resultI = resultQ.items {
            return resultI.sorted { $0.title! < $1.title! }
        }
        else {
            return []
        }
    }
    
    /// Returns all the songs in the Media Library
    /// - Returns: A MPMediaItem array with all the songs
    class public func getSongsList() -> [MPMediaItem] {
        
        // Perform the same query with an empty artist name and album title to get all the songs in the Media Library
        return getSongsList(byArtist: "", byAlbum: "")
    }
	
    /// Returns all the songs for a given Artist in the Media Library
    /// - Returns: A MPMediaItem array with all the songs
	class public func getSongsList(byArtist: String) -> [MPMediaItem] {
        return getSongsList(byArtist: byArtist, byAlbum: "")
    }
	

    /// Returns all the created playlist in the Media Library
    /// - Returns: A MPMediaCollection array with all the playlists
    class public func getPlaylistList() -> [MPMediaItemCollection] {
        
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
	class public func getPlaylistItem(byPlaylistName: String?) -> MPMediaItem? {
		
		guard let playlistName = byPlaylistName else { return nil }
        
		var query: MPMediaQuery?
		
		// Set a filter by the playlist name
		let playlistFilter = MPMediaPropertyPredicate(value: playlistName, forProperty: MPMediaPlaylistPropertyName, comparisonType: MPMediaPredicateComparison.equalTo)

		let myFilterSet: Set<MPMediaPropertyPredicate> = [playlistFilter]
	
		// Perform the query
		query = MPMediaQuery(filterPredicates: myFilterSet)

		if let resultQ = query, let resultI = resultQ.items {
			return resultI.first
        }
        else {
            return nil
        }
    }

    /// Returns an specific artist's item
    /// - Returns: A MPMediaItem with the artist
	class public func getArtistItem(byArtistName: String?) -> MPMediaItem? {
		
		guard let artistName = byArtistName else { return nil }
        
		var query: MPMediaQuery?
		
		// Set a filter by the artist name
		let artistFilter = MPMediaPropertyPredicate(value: artistName, forProperty: MPMediaItemPropertyAlbumArtist, comparisonType: MPMediaPredicateComparison.equalTo)

		let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter]
	
		// Perform the query
		query = MPMediaQuery(filterPredicates: myFilterSet)

		if let resultQ = query, let resultI = resultQ.items {
			return resultI.first
        }
        else {
            return nil
        }
    }

    /// Returns an specific album's item
    /// - Returns: A MPMediaItem with the album
	class public func getAlbumItem(byArtistName: String?, byAlbumTitle: String?) -> MPMediaItem? {
		
		guard let artistName = byArtistName, let albumTitle = byAlbumTitle else { return nil }
        
		var query: MPMediaQuery?
		
		// Set a composed filter by the artist name and album title
		let artistFilter = MPMediaPropertyPredicate(value: artistName, forProperty: MPMediaItemPropertyAlbumArtist, comparisonType: MPMediaPredicateComparison.equalTo)
		let albumFilter  = MPMediaPropertyPredicate(value: albumTitle, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo)

		let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter, albumFilter]
	
		// Perform the query
		query = MPMediaQuery(filterPredicates: myFilterSet)

		if let resultQ = query, let resultI = resultQ.items {
			return resultI.first
        }
        else {
            return nil
        }
    }

    /// Returns an specific song's item
    /// - Returns: A MPMediaItem with the song
	class public func getSongItem(byArtistName: String?, byAlbumTitle: String?, bySongTitle: String?) -> MPMediaItem? {
		
		guard let artistName = byArtistName, let albumTitle = byAlbumTitle, let songTitle = bySongTitle else { return nil }
        
		var query: MPMediaQuery?
		
		// Set a composed filter by the artist name, album title and song title filter
		let artistFilter = MPMediaPropertyPredicate(value: artistName, forProperty: MPMediaItemPropertyAlbumArtist, comparisonType: MPMediaPredicateComparison.equalTo)
		let albumFilter  = MPMediaPropertyPredicate(value: albumTitle, forProperty: MPMediaItemPropertyAlbumTitle, comparisonType: MPMediaPredicateComparison.equalTo)
		let songFilter   = MPMediaPropertyPredicate(value: songTitle, forProperty: MPMediaItemPropertyTitle, comparisonType: MPMediaPredicateComparison.equalTo)

		let myFilterSet: Set<MPMediaPropertyPredicate> = [artistFilter, albumFilter, songFilter]
	
		// Perform the query
		query = MPMediaQuery(filterPredicates: myFilterSet)

		if let resultQ = query, let resultI = resultQ.items {
			return resultI.first
        }
        else {
            return nil
        }
    }

    /// Returns an specific playlist's artwork
    /// - Returns: The playlist's MPMediaItemArtwork Image
	class public func getPlaylistArtworkImage(byPlaylistName: String) -> UIImage? {
		
		guard let item = getPlaylistItem(byPlaylistName: byPlaylistName) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }

    /// Returns an specific artist's artwork
    /// - Returns: The artist's MPMediaItemArtwork Image
	class public func getArtistArtworkImage(byArtistName: String) -> UIImage? {
		
		guard let item = getArtistItem(byArtistName: byArtistName) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }

    /// Returns an specific album's artwork
    /// - Returns: The album's MPMediaItemArtwork Image
	class public func getAlbumArtworkImage(byArtistName: String, byAlbumTitle: String) -> UIImage? {
		
		guard let item = getAlbumItem(byArtistName: byArtistName, byAlbumTitle: byAlbumTitle) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }
	
    /// Returns an specific song's artwork
    /// - Returns: The song's MPMediaItemArtwork Image
	class public func getSongArtworkImage(byArtistName: String?, byAlbumTitle: String?, bySongTitle: String?) -> UIImage? {
		
		guard let item = getSongItem(byArtistName: byArtistName, byAlbumTitle: byAlbumTitle, bySongTitle: bySongTitle) else { return nil }
		
		return item.artwork?.image(at: CGSize.zero)
    }


}

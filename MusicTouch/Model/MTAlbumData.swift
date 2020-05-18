//
//  Album.swift
//  iTunesTest
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

let ALBUMYEAR_DEFAULT: Int = 1900

class MTAlbumData: MTData {
    var albumTitle: String = ""
    var artistName: String = ""
	var numberOfSongs: Int { get { return self.getSongsListFromMediaLibrary().count } }
    var year: Int = ALBUMYEAR_DEFAULT
	
	var songs: [MTSongData] {
		get {
			return self.getSongsListFromMediaLibrary()
					   .sorted { $0.albumTrackNumber < $1.albumTrackNumber }
					   .map { MTSongData(mediaItem: $0, mediaLibrary: self.mediaLibrary) }
		}
	}
    
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for song in songs {
            secs += song.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
	init(persistentID: MPMediaEntityPersistentID, artistName: String, albumTitle: String, year: Int = ALBUMYEAR_DEFAULT, mediaLibrary: MediaLibraryProtocol) {
		super.init(persistentID: persistentID, mediaLibrary: mediaLibrary)
		
        self.artistName    = artistName
        self.albumTitle    = albumTitle
        self.year          = year
    }
	
	/// Gets the album title
	/// - Returns: Album title
    func title() -> String {
		return self.albumTitle
    }
	
	/// Gets the album's artwork image
	/// - Returns: Album's artwork image
    func image() -> UIImage? {
		return mediaLibrary.getAlbumArtworkImage(byAlbumPersistentID: self.persistentID)
    }
    
	/// Prints the album description to the stadard output (for debugging purposes only)
	/// - Parameter offset: numer of heading scpaces
    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Album: *\(self.title())*")
        for song in self.songs {
            song.describe(offset: offset + 2)
        }
    }
    
	/// Gets the album's song list from the Media Library
	/// - Returns: album's songs list in a MPMediaItemCollection object
    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: getSongsListFromMediaLibrary())
    }
	
	/// Gets the album's song list from the Media Library
	/// - Returns: album's song list
	private func getSongsListFromMediaLibrary() -> [MPMediaItem] {
		return self.mediaLibrary.getSongsList(byAlbumPersistentID: self.persistentID)
	}
	
}


struct AlbumID: Hashable {
    var artist: String?
    var album: String?
    
    init(artist: String?, album: String?) {
        self.artist = artist
        self.album  = album
    }
    
    public var hashValue: Int {
        guard (self.artist != nil) else { return Int.max }
        guard (self.album  != nil) else { return Int.max }
        
        return (artist! + album!).hashValue
    }
}

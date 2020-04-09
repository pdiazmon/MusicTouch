//
//  Album.swift
//  iTunesTest
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

let ALBUMYEAR_DEFAULT:Int = 1900

class MTAlbumData: MTData {
    var albumTitle: String = ""
    var artistName: String = ""
    var numberOfSongs: Int { get { return songs.count } }
    var year: Int = ALBUMYEAR_DEFAULT
	
	let albumQueue = DispatchQueue(label: "album")
	
	lazy var songs: [MTSongData] = []
    
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for song in songs {
            secs += song.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
	init(persistentID: MPMediaEntityPersistentID, artistName: String, albumTitle: String, year: Int = ALBUMYEAR_DEFAULT) {
		super.init()
		
        self.artistName    = artistName
        self.albumTitle    = albumTitle
        self.year          = year
        self.songs         = []
		self.persistentID  = persistentID
		
		albumQueue.async {
			self.songs = PDMMediaLibrary.getSongsList(byAlbumPersistentID: self.persistentID)
						 .sorted { $0.albumTrackNumber < $1.albumTrackNumber }
				         .map { MTSongData(mediaItem: $0) }
		}
    }
    
    func title() -> String {
		return self.albumTitle
    }
    
    func image() -> UIImage? {
		return PDMMediaLibrary.getAlbumArtworkImage(byAlbumPersistentID: self.persistentID)
    }
    
    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Album: *\(self.title())*")
        for song in self.songs {
            song.describe(offset: offset + 2)
        }
    }
    
    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: PDMMediaLibrary.getSongsList(byAlbumPersistentID: self.persistentID))
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

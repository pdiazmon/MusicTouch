//
//  MTSongData.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

class MTSongData: MTData {

	private var _albumArtist: String?
	private var _albumTitle: String?
	private var _songTitle: String?
	private var _albumTrackNumber: Int
	private var _playbackDuration: TimeInterval
	
    var mediaItem: MPMediaItem? {
		get {
			return PDMMediaLibrary.getSongItem(byArtistName: self._albumArtist, byAlbumTitle: self._albumTitle, bySongTitle: self._songTitle)
		}
	}

    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
		return fromSeconds(seconds: Int(self._playbackDuration) )
    } }
    
    init(mediaItem: MPMediaItem) {        
		self._albumArtist       = mediaItem.albumArtist
		self._albumTitle        = mediaItem.albumTitle
		self._songTitle         = mediaItem.title
		self._albumTrackNumber  = mediaItem.albumTrackNumber
		self._playbackDuration  = mediaItem.playbackDuration
    }
    
    func title() -> String {
		return (self._songTitle == nil) ? "" : "\(self._albumTrackNumber). \(self._songTitle!)"
    }
	
	func albumArtist() -> String {
		return (self._albumArtist == nil) ? "" : self._albumArtist!
	}
	
	func albumTitle() -> String {
		return (self._albumTitle == nil) ? "" : self._albumTitle!
	}

	func albumTrackNumber() -> Int {
		return self._albumTrackNumber
	}
	
	func songTitle() -> String {
		return (self._songTitle == nil) ? "" : self._songTitle!
	}
	
    func image() -> UIImage? {
		return PDMMediaLibrary.getSongArtworkImage(byArtistName: self._albumArtist, byAlbumTitle: self._albumTitle, bySongTitle: self._songTitle)
    }

    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Song: *\(self.title())*")
    }
	
    func songsCollection() -> MPMediaItemCollection {
		let item = self.mediaItem
		
		return (item == nil) ? MPMediaItemCollection(items: []) : MPMediaItemCollection(items: [item!])
    }

}

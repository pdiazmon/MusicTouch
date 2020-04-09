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
	private var _albumTrackNumber: Int?
	private var _playbackDuration: TimeInterval?
	
    var mediaItem: MPMediaItem? {
		get {
			return PDMMediaLibrary.getSongItem(byPersistentID: self.persistentID)
		}
	}

    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
		return fromSeconds(seconds: Int(self._playbackDuration!) )
    } }
    
    init(mediaItem: MPMediaItem) {
		super.init()
		
		self._albumArtist       = mediaItem.albumArtist
		self._albumTitle        = mediaItem.albumTitle
		self._songTitle         = mediaItem.title
		self._albumTrackNumber  = mediaItem.albumTrackNumber
		self._playbackDuration  = mediaItem.playbackDuration
		self.persistentID       = mediaItem.persistentID
    }
    
    func title() -> String {
		return (self._songTitle == nil) ? "" : "\(self.albumTrackNumber()). \(self.songTitle())"
    }
	
	func albumArtist() -> String {
		return (self._albumArtist == nil) ? "" : self._albumArtist!
	}
	
	func albumTitle() -> String {
		return (self._albumTitle == nil) ? "" : self._albumTitle!
	}

	func albumTrackNumber() -> Int {
		return (self._albumTrackNumber != nil) ? self._albumTrackNumber! : 0
	}
	
	func songTitle() -> String {
		return (self._songTitle == nil) ? "" : self._songTitle!
	}
	
    func image() -> UIImage? {
		return PDMMediaLibrary.getSongArtworkImage(byPersistentID: self.persistentID)
    }

    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Song: *\(self.title())*")
    }
	
    func songsCollection() -> MPMediaItemCollection {
		let item = self.mediaItem
		
		return (item == nil) ? MPMediaItemCollection(items: []) : MPMediaItemCollection(items: [item!])
    }

}

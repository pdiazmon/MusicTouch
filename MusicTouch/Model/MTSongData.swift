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
			return mediaLibrary.getSongItem(byPersistentID: self.persistentID)
		}
	}

    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
		return fromSeconds(seconds: Int(self._playbackDuration!) )
    } }
    
	init(mediaItem: MPMediaItem, mediaLibrary: MediaLibraryProtocol) {
		super.init(persistentID: mediaItem.persistentID, mediaLibrary: mediaLibrary)
		
		self._albumArtist       = mediaItem.albumArtist
		self._albumTitle        = mediaItem.albumTitle
		self._songTitle         = mediaItem.title
		self._albumTrackNumber  = mediaItem.albumTrackNumber
		self._playbackDuration  = mediaItem.playbackDuration
    }
	
	/// Gets the song title
	/// - Returns: Song title
    func title() -> String {
		return (self._songTitle == nil) ? "" : "\(self.albumTrackNumber()). \(self.songTitle())"
    }
	
	/// Gets the artist name
	/// - Returns: Artist name
	func albumArtist() -> String {
		return self._albumArtist ?? ""
	}
	
	/// Gets the album title
	/// - Returns: Album title
	func albumTitle() -> String {
		return self._albumTitle ?? ""
	}
	
	/// Gets the song's track number
	/// - Returns: Song's track number
	func albumTrackNumber() -> Int {
		return self._albumTrackNumber ?? 0
	}
	
	/// Gets the song title
	/// - Returns: Song title
	private func songTitle() -> String {
		return self._songTitle ?? ""
	}
	
	/// Gets the song's artwork image
	/// - Returns: Song's artwork image
    func image() -> UIImage? {
		return mediaLibrary.getSongArtworkImage(byPersistentID: self.persistentID)
    }

	/// Prints the song description to the stadard output (for debugging purposes only)
	/// - Parameter offset: numer of heading scpaces
    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Song: *\(self.title())*")
    }
	
	/// Gets the song as a single item in a collection
	/// - Returns: Song in a MPMediaItemCollection object
    func songsCollection() -> MPMediaItemCollection {
		let item = self.mediaItem
		
		return (item == nil) ? MPMediaItemCollection(items: []) : MPMediaItemCollection(items: [item!])
    }

}

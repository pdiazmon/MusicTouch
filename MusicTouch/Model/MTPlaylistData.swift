//
//  Playlist.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

class MTPlaylistData: MTData {
    
    var name: String = ""
	var numberOfSongs: Int { get { return mediaLibrary.getSongsList(byPlaylist: name).count } }
    var songs: [MTSongData] = []
	
	private let playlistQueue = DispatchQueue(label: "playlist")
	
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for song in songs {
            secs += song.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
	init(persistentID: MPMediaEntityPersistentID?, name: String, mediaLibrary: MediaLibraryProtocol) {
		super.init(persistentID: persistentID ?? 0, mediaLibrary: mediaLibrary)
		
        self.name          = name
        self.songs         = []
		
		playlistQueue.async {
			self.songs = mediaLibrary.getSongsList(byPlaylist: name).map {
				MTSongData(mediaItem: $0, mediaLibrary: mediaLibrary)
			}.sorted {
				if ($0.albumTitle() == $1.albumTitle()) { return $0.albumTrackNumber() < $1.albumTrackNumber() }
				else { return $0.albumTitle() < $1.albumTitle() }
			}
		}
    }
    
    func title() -> String {
        return name
    }
    
    func image() -> UIImage? {
		return mediaLibrary.getPlaylistArtworkImage(byPersistentID: self.persistentID)
    }
    
    func describe(offset: Int) {
        print("Playlist: *\(self.name)*")
        for song in self.songs {
            song.describe(offset: offset + 2)
        }
    }

    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: mediaLibrary.getSongsList(byPlaylist: self.name))
    }

}

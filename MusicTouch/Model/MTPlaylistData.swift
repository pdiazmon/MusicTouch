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
    
    var name: String
    var numberOfSongs: Int { get { return songs.count } }
    var songs: [MTSongData]
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for song in songs {
            secs += song.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
	init(name: String) {
        self.name          = name
        self.songs         = []
    }
    
    func title() -> String {
        return name
    }
    
    func image() -> UIImage? {
		return PDMMediaLibrary.getPlaylistArtworkImage(byPlaylistName: self.name)
    }
    
    func describe(offset: Int) {
        print("Playlist: *\(self.name)*")
        for song in self.songs {
            song.describe(offset: offset + 2)
        }
        
    }

    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: PDMMediaLibrary.getSongsList(byPlaylist: self.name))
    }

}

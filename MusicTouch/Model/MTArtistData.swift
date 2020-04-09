//
//  Artist.swift
//  iTunesTest2
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit


class MTArtistData: MTData {
    var name: String = ""
    var numberOfAlbums: Int { get { return albums.count } }
    var albums: [MTAlbumData] = []
	
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for album in albums {
            secs += album.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
	init(persistentID: MPMediaEntityPersistentID, name: String) {
		super.init()
		
        self.name           = name
        self.albums         = []
		self.persistentID   = persistentID
    }
    
    func title() -> String {
        return name
    }
    
    func image() -> UIImage? {
		return PDMMediaLibrary.getArtistArtworkImage(byArtistPersistentID: self.persistentID)
    }
    
    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Artist: *\(self.name)*")
        for album in albums {
            album.describe(offset: offset + 2)
        }
    }
    
    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: PDMMediaLibrary.getSongsList(byArtistPersistentID: self.persistentID))
    }
    
}


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
	
	let artistQueue = DispatchQueue(label: "artist")
	
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for album in albums {
            secs += album.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
	init(persistentID: MPMediaEntityPersistentID, name: String, mediaLibrary: MediaLibraryProtocol) {
		super.init(persistentID: persistentID, mediaLibrary: mediaLibrary)
		
        self.name           = name
        self.albums         = []
		
		artistQueue.async {
			self.albums = mediaLibrary.getAlbumsList(byArtistPersistentID: self.persistentID)
				          .map { MTAlbumData(persistentID: $0.albumPersistentID,
								   artistName: name,
								   albumTitle: $0.albumTitle ?? "",
								   year: ($0.releaseDate != nil) ? Calendar.current.component(.year, from: $0.releaseDate!) : ALBUMYEAR_DEFAULT,
								   mediaLibrary: mediaLibrary)
						  }
				          .sorted {
								if ($0.year == $1.year) { return $0.albumTitle < $1.albumTitle }
								else { return $0.year < $1.year}
						  }
		}
    }
    
    func title() -> String {
        return name
    }
    
    func image() -> UIImage? {
		return mediaLibrary.getArtistArtworkImage(byArtistPersistentID: self.persistentID)
    }
    
    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Artist: *\(self.name)*")
        for album in albums {
            album.describe(offset: offset + 2)
        }
    }
    
    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: mediaLibrary.getSongsList(byArtistPersistentID: self.persistentID))
    }
    
}


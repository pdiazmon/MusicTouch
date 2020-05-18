//
//  Artist.swift
//  iTunesTest2
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

class MTArtistData: MTData {
    var name: String = ""
	var numberOfAlbums: Int {
		get {
			return self.getAlbumsListFromMediaLibrary().count
		}
	}
	
	var albums: [MTAlbumData] {
		get {
			return self.getAlbumsListFromMediaLibrary()
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
	
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) {
		get {
			var secs: Int = 0
			for album in albums {
				secs += album.toSeconds()
			}
			return fromSeconds(seconds: secs)
		}
	}
    
	init(persistentID: MPMediaEntityPersistentID, name: String, mediaLibrary: MediaLibraryProtocol) {
		super.init(persistentID: persistentID, mediaLibrary: mediaLibrary)
		
        self.name = name
    }
	
	/// Gets the artist name
	/// - Returns: Artist name
    func title() -> String {
        return name
    }
	
	/// Gets the artist's artwork image
	/// - Returns: Artist's artwork image
    func image() -> UIImage? {
		return mediaLibrary.getArtistArtworkImage(byArtistPersistentID: self.persistentID)
    }
    
	/// Prints the artist description to the stadard output (for debugging purposes only)
	/// - Parameter offset: numer of heading scpaces
    func describe(offset: Int) {
        print("\(String(repeating: " ", count: offset))Artist: *\(self.name)*")
        for album in albums {
            album.describe(offset: offset + 2)
        }
    }
    
	/// Gets the artist's song list from the Media Library
	/// - Returns: artist's songs list in a MPMediaItemCollection object
    func songsCollection() -> MPMediaItemCollection {
		return MPMediaItemCollection(items: getAlbumsListFromMediaLibrary())
    }
    
	/// Gets the artist's album list from the Media Library
	/// - Returns: artist's album list
	private func getAlbumsListFromMediaLibrary() -> [MPMediaItem] {
		return mediaLibrary.getAlbumsList(byArtistPersistentID: self.persistentID)
	}
	
}


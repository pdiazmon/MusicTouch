//
//  Album.swift
//  iTunesTest
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

let ALBUMYEAR_DEFAULT:Int = 1900

class MTAlbumData: MTData {    
    var albumTitle: String
    var artistName: String
    var numberOfSongs: Int { get { return songs.count } }
    var year: Int 
    var songs: [MTSongData]
    
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for song in songs {
            secs += song.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
    init(image: UIImage?, artistName: String, albumTitle: String, year: Int = ALBUMYEAR_DEFAULT) {
        self.artistName    = artistName
        self.albumTitle    = albumTitle
        self.year          = year
        self.songs         = []

        super.init(image: image)
    }
    
    func title() -> String {
        return albumTitle
    }
    
    func image() -> UIImage? {
        return image
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

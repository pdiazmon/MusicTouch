//
//  Artist.swift
//  iTunesTest2
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit


class MTArtistData: MTData {
   
    var name: String
    var numberOfAlbums: Int { get { return albums.count } }
    var albums: [MTAlbumData]
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        var secs: Int = 0
        for album in albums {
            secs += album.toSeconds()
        }
        return fromSeconds(seconds: secs)
    } }
    
    init(image: UIImage?, name: String) {
        self.name           = name
        self.albums         = []
        
        super.init(image: image)
    }
    
    func title() -> String {
        return name
    }
    
    func image() -> UIImage? {
        return image
    }
    
}

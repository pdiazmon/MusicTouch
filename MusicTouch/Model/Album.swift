//
//  Album.swift
//  iTunesTest
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

// MARK: Item struct
struct Album: Equatable {
    var artist: String
    var album: String
    var image: UIImage?
    
    func isTheSame(_ item: Album) -> Bool {
        return self.album == item.album && self.artist == item.artist
    }
}

func ==(item1: Album, item2: Album) -> Bool {
    return item1.album == item2.album && item1.artist == item2.artist
}

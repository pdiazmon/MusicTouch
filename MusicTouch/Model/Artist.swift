//
//  Artist.swift
//  iTunesTest2
//
//  Created by Pedro L. Diaz Montilla on 13/2/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

struct Artist: Equatable {
    var artist: String
    var image: UIImage?
    
    func isTheSame(_ item: Artist) -> Bool {
        return self.artist == item.artist
    }
}

func ==(item1: Artist, item2: Artist) -> Bool {
    return item1.artist == item2.artist
}

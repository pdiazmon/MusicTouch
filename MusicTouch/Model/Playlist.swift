//
//  Playlist.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

struct Playlist: Equatable {
    var title: String
    var image: UIImage?
    
    func isTheSame(_ item: Playlist) -> Bool {
        return self.title == item.title
    }
}

func ==(item1: Playlist, item2: Playlist) -> Bool {
    return item1.title == item2.title
}

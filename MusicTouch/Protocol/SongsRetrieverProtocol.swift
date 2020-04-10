//
//  SongsRetrieverProtocol.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 10/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

protocol SongsRetrieverProtocol {
    func songsCollection() -> MPMediaItemCollection
}

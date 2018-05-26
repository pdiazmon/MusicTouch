//
//  Constant.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation

// Enum all the TabBar controller buttons
enum TabBarItem: Int {
    case playlist = 0
    case artist   = 1
    case album    = 2
    case song     = 3
    case play     = 4
}


// Enum all the app possible statuses
enum AppStatus {
    case foreground
    case background
}

//
//  MTCellFactory.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 26/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

enum MTCellStyle: Int {
    case paris
    case london
}

class MTCellFactory {
    
    static let shared = MTCellFactory()
    
    var style: MTCellStyle
    
    private init(style: MTCellStyle = .paris) {
        self.style = style
    }
	
	/// Factory for cells
	/// - Returns: Cell class
    func classForCoder() -> AnyClass {
        switch style {
        case .paris:
            return MTCellParis.classForCoder()
        case .london:
            return MTCellLondon.classForCoder()
        }
    }
    
	/// Render the cell elements with the appropiate data
	/// - Parameter item: data item
	/// - Parameter cell: cell to be rendered
    func render(cell: MTCell, item: MTData) {
        switch style {
        case .paris:
            if let myCell = (cell as? MTCellParis) { myCell.render(item: item) }
        case .london:
            if let myCell = (cell as? MTCellLondon) { myCell.render(item: item) }
        }
    }
	
	/// Gets the color for the given element
	/// - Parameter item: tab bar item to be colored
	/// - Returns: color for the tab bar item
    func londonColor(_ item: TabBarItem) -> UIColor {
        switch item {
        case .playlist:
            return UIColor.blue
        case .artist:
            return UIColor.red
        case .album:
            return UIColor.purple
        case .song:
            return UIColor.green
        default:
            return UIColor.gray
        }
    }
}

//
//  MTCellDelegateProtocol.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

typealias MTCellDelegate = MTCellDelegateProtocol & UIView

protocol MTCellDelegateProtocol {
    func setup()
    func layoutView()
    func style()
    func render(item: MTData)
    
}

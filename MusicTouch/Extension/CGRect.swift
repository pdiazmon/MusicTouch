//
//  CGRect.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 14/7/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
	/// Scales the CGRect by a given proportion
	/// - Parameter proportion: proportion to scale
	/// - Returns: a new scaled CGRect
    func scale(by proportion: CGFloat) -> CGRect {
        return CGRect(origin: CGPoint(x: self.width * (1-proportion)/2, y: self.height * (1-proportion)/2),
                      size: CGSize(width: self.width * proportion, height: self.height * proportion))
    }
}

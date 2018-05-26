//
//  UIImageView.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 22/5/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Set the UIImage and round it to be a circle
    ///
    /// - Parameter image: image to be set
    func setAndRound(_ image: UIImage) {
        self.image = image
        
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds      = true
    }
}

//
//  VolumeView.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 31/5/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class VolumeView: UIView {

    private let volumeText = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(color: UIColor) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = color.withAlphaComponent(0.4)
        
        self.addSubview(volumeText)
        
        volumeText.font          = volumeText.font.withSize(25)
        volumeText.textColor     = UIColor.white
        volumeText.shadowColor   = UIColor.lightGray
        volumeText.textAlignment = .center
        
    }
    
    /// Shows the transparent view with the appropiate size according to the volume value
    ///
    /// - Parameter volume: volume value
    public func changeVolume(to volume: CGFloat) {
        guard (self.superview != nil) else { return }
        
        let viewHeight = self.superview!.safeAreaLayoutGuide.layoutFrame.height
        
        self.frame = CGRect(x: 0,
                            y: viewHeight * (1-volume),
                            width: self.superview!.safeAreaLayoutGuide.layoutFrame.width,
                            height: viewHeight * volume)
        
        // Do not show the volume value label if volume value is less than 10% as the view is too small
        if (volume >= 0.1) {
            volumeText.text = "\(Int(volume*100))%"
            volumeText.sizeToFit()
            // Locate the volume value label at the center of the transparent view
            volumeText.center.x = self.center.x
            volumeText.center.y = self.bounds.height/2
            volumeText.isHidden = false
        }
        else {
            volumeText.isHidden = true
        }
    }
    
    /// Makes the transparent view visible
    public func show() {
        self.isHidden = false
    }
    
    /// Hides the transparent view
    public func hide() {
        self.isHidden = true
    }
}

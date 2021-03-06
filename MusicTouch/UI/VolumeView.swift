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
        
        // Locate the volume value label at the center of the transparent view
        volumeText.translatesAutoresizingMaskIntoConstraints = false
        volumeText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        volumeText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    /// Shows the transparent view with the appropiate size according to the volume value
    ///
    /// - Parameter volume: volume value
    public func changeVolume(to volume: CGFloat, viewController: UIViewController) {
        guard (self.superview != nil)                  else { return }
        guard (viewController.tabBarController != nil) else { return }
        
        /*
           View height is calculated based in the tabBar height instead of using an AutoLayout constraint to the Safe Area bottom anchor.
           I have made a lot of tests based on the idea that an autolayout constraint is the best and more elegant solution,
           but when the screen is rotated to the landscape mode the safe area size is not updated properly by the system.
           Even, when you get its size programmatically, the returned value is wrong once the device is rotated.
           And it happens when you rotate again the device to portrait mode. The returned safe area size value is not the same
           as you got when the app was launched.
           So strange.
        */
        
        let viewHeight         = self.superview!.frame.height
        let tabBarHeight       = viewController.tabBarController!.tabBar.frame.height
        let safeAreaViewHeight = viewHeight - tabBarHeight
        let volumeHeight       = safeAreaViewHeight * volume
        let yCorner            = viewHeight - volumeHeight - tabBarHeight
        
        self.frame = CGRect(x: 0,
                            y: yCorner,
                            width: self.superview!.safeAreaLayoutGuide.layoutFrame.width,
                            height: volumeHeight)
        
        // Do not show the volume value label if volume value is less than 10% as the view is too small
        if (volume >= 0.1) {
            volumeText.text = "\(Int(volume*100))%"
            volumeText.sizeToFit()
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

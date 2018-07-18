//
//  NVActivityIndicatorViewFactory.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 14/7/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class NVActivityIndicatorViewFactory {
    
    static let shared = NVActivityIndicatorViewFactory()
    
    func getNewLoading(frame: CGRect) -> NVActivityIndicatorView {
        
        return NVActivityIndicatorView(frame: CGRect(x: frame.width * 0.25,
                                                     y: frame.height * 0.5,
                                                     width: frame.width * 0.5,
                                                     height: frame.height * 0.07),
                                       type: .ballPulse,
                                       color: UIColor.gray,
                                       padding: nil)
    }
    
    func getNewPlaying(frame: CGRect) -> NVActivityIndicatorView {
        return NVActivityIndicatorView(frame: CGRect(x: frame.width,
                                                     y: frame.height,
                                                     width: frame.width,
                                                     height: frame.height),
                                       type: .audioEqualizer,
                                       color: UIColor.red,
                                       padding: nil)

    }
    
}

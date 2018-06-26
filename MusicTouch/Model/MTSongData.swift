//
//  MTSongData.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

class MTSongData: MTData {
    
    public var mediaItem: MPMediaItem
    override public var playTime: (hours: Int, minutes: Int, seconds: Int) { get {
        return fromSeconds(seconds: Int(mediaItem.playbackDuration) )
    } }
    
    init(mediaItem: MPMediaItem) {        
        self.mediaItem = mediaItem
        
        super.init(image: self.mediaItem.artwork?.image(at: CGSize.zero))
        
//        self.playTime = self.fromSeconds(seconds: Int(mediaItem.playbackDuration))
    }
    
    func title() -> String {
        guard let title = mediaItem.title else { return "" }
        
        return "\(mediaItem.albumTrackNumber). \(title)"
    }
    
    func image() -> UIImage? {
        return mediaItem.artwork?.image(at: CGSize.zero)
    }


}

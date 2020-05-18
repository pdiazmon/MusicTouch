//
//  MTData.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

typealias MTData = MTDataRoot & MTDataProtocol & SongsRetrieverProtocol

class MTDataRoot {
    public var playTime: (hours: Int, minutes: Int, seconds: Int) { get { return (0,0,0) } }
	
	public var persistentID: MPMediaEntityPersistentID = 0
	var mediaLibrary: MediaLibraryProtocol
    
	public init(persistentID: MPMediaEntityPersistentID, mediaLibrary: MediaLibraryProtocol) {
		self.persistentID = persistentID
		self.mediaLibrary = mediaLibrary
	}
	
	/// Gets the item playtime in seconds
	/// - Returns: <#description#>
    func toSeconds() -> Int {
        return playTime.hours * 3600 + playTime.minutes * 60 + playTime.seconds
    }
	
	/// Converts seconds in a (hours, minutes, seconds) tuple
	/// - Parameter seconds: seconds amount to convert
	/// - Returns: (hours, minutes, seconds)
    func fromSeconds(seconds: Int) -> (Int, Int, Int) {
        let _hour = Int(seconds / 3600)
        let rem = seconds % 3600
        let _min = Int(rem / 60)
        let _sec = rem % 60
        
        return (_hour, _min, _sec)
    }
    
}

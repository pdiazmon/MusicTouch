//
//  PlayerProtocol.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 14/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

protocol PlayerProtocol {
	
    func getPlayer() -> MPMusicPlayerController
    
    func shuffleModeOn()
    
	func shuffleModeOff()
    
	func playSong()
    
	func pauseSong()
    
	func setCollection(_ collection: MPMediaItemCollection)
    
	func getCollection() -> MPMediaItemCollection
    
	func setSong(_ song: MPMediaItem?)
    
	func nowPlayingArtwork() -> MPMediaItemArtwork?
    
	func nowPlayingTitle() -> String?

	func nowPlayingAlbumTitle() -> String?

	func nowPlayingArtist() -> String?
    
	func nowPlayingPlaybackTime() -> TimeInterval

	func nowPlayingDuration() -> TimeInterval

	func playNext()

	func playPrevious()
    
	func isPlayingFirst() -> Bool

	func isPlayingLast() -> Bool
    
	func isPlaying() -> Bool
	
	func isPaused() -> Bool
    
	func isShuffleOn() -> Bool

}

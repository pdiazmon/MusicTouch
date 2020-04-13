//
//  PlayController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class PlayController {
	
	private var app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
	var tabBarController: UITabBarController?
	weak var viewController: PlayViewController?
	
	init(tabBarController: UITabBarController, viewController: PlayViewController) {
		self.tabBarController = tabBarController
		self.viewController   = viewController
	}
	
	func setup() {
        // Add an observer: when the playing song changes over the self.app.appPlayer object
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: self.app.appPlayer.getPlayer())
        self.app.appPlayer.getPlayer().beginGeneratingPlaybackNotifications()

	}
	
	 @objc func updateView() {
		guard let vc = self.viewController else { return }
		
		vc.updateView()
	}
	
	func isPlaying() -> Bool {
		return self.app.appPlayer.isPlaying()
	}
	
	func isPaused() -> Bool {
		return self.app.appPlayer.isPaused()
	}
	
	func isPlayingLast() -> Bool {
		return app.appPlayer.isPlayingLast()
	}
	
	func isPlayingFirst() -> Bool {
		   return app.appPlayer.isPlayingFirst()
	   }
	
	func playSong() {
		return self.app.appPlayer.playSong()
	}
	
	func pauseSong() {
		return self.app.appPlayer.pauseSong()
	}
	
	func nowPlayingArtist() -> String? {
		return self.app.appPlayer.nowPlayingArtist()
	}
	
	func nowPlayingAlbumTitle() -> String? {
		return self.app.appPlayer.nowPlayingAlbumTitle()
	}
	
	func nowPlayingTitle() -> String? {
		return self.app.appPlayer.nowPlayingTitle()
	}
	
	func nowPlayingArtwork() -> MPMediaItemArtwork? {
		return self.app.appPlayer.nowPlayingArtwork()
	}
	
	func isShuffleOn() -> Bool {
		return self.app.appPlayer.isShuffleOn()
	}
	
	func nowPlayingPlaybackTime() -> TimeInterval {
		return app.appPlayer.nowPlayingPlaybackTime()
	}
	
	func nowPlayingDuration() -> TimeInterval {
		return app.appPlayer.nowPlayingDuration()
	}
	
	func playPrevious() {
		app.appPlayer.playPrevious()
	}
	
	func playNext() {
		app.appPlayer.playNext()
	}
	
	func appStatus() -> AppStatus {
		return app.appStatus
	}
}

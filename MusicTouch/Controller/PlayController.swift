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
	
	private var tabBarController: UITabBarController?
	private weak var viewController: PlayViewController?
	private var player: PlayerProtocol
	private var app: ApplicationProtocol
	
	init(tabBarController: UITabBarController, viewController: PlayViewController, player: PlayerProtocol, app: ApplicationProtocol) {
		self.tabBarController = tabBarController
		self.viewController   = viewController
		self.player           = player
		self.app              = app
	}
	
	func setup() {
        // Add an observer: when the playing song changes over the self.app.appPlayer object
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: self.player.getPlayer())
        self.player.getPlayer().beginGeneratingPlaybackNotifications()

	}
	
	 @objc func updateView() {
		guard let vc = self.viewController else { return }
		
		vc.updateView()
	}
	
	func getPlayer() -> PlayerProtocol {
		return self.player
	}
	
	func isPlaying() -> Bool {
		return self.player.isPlaying()
	}
	
	func isPaused() -> Bool {
		return self.player.isPaused()
	}
	
	func isPlayingLast() -> Bool {
		return self.player.isPlayingLast()
	}
	
	func isPlayingFirst() -> Bool {
		   return self.player.isPlayingFirst()
	   }
	
	func playSong() {
		return self.player.playSong()
	}
	
	func pauseSong() {
		return self.player.pauseSong()
	}
	
	func nowPlayingArtist() -> String? {
		return self.player.nowPlayingArtist()
	}
	
	func nowPlayingAlbumTitle() -> String? {
		return self.player.nowPlayingAlbumTitle()
	}
	
	func nowPlayingTitle() -> String? {
		return self.player.nowPlayingTitle()
	}
	
	func nowPlayingArtwork() -> MPMediaItemArtwork? {
		return self.player.nowPlayingArtwork()
	}
	
	func isShuffleOn() -> Bool {
		return self.player.isShuffleOn()
	}
	
	func nowPlayingPlaybackTime() -> TimeInterval {
		return self.player.nowPlayingPlaybackTime()
	}
	
	func nowPlayingDuration() -> TimeInterval {
		return self.player.nowPlayingDuration()
	}
	
	func playPrevious() {
		self.player.playPrevious()
	}
	
	func playNext() {
		self.player.playNext()
	}
	
	func appStatus() -> AppStatus {
		return self.app.getAppStatus()
	}
}

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
	
	/// Forces the view update
	@objc func updateView() {
		guard let vc = self.viewController else { return }
		
		vc.updateView()
	}
	
	/// Gets the player object
	/// - Returns: Player object
	func getPlayer() -> PlayerProtocol {
		return self.player
	}
	
	/// Indicates if the music is playing
	/// - Returns: true if yes, false if not
	func isPlaying() -> Bool {
		return self.player.isPlaying()
	}
	
	/// Indicates if the music is paused
	/// - Returns: true if yes, false if not
	func isPaused() -> Bool {
		return self.player.isPaused()
	}
	
	/// Indicates if the song being played is the last one of the list
	/// - Returns: true if yes, false if not
	func isPlayingLast() -> Bool {
		return self.player.isPlayingLast()
	}
	
	/// Indicates if the song being played is the first one of the list
	/// - Returns: true if yes, false if not
	func isPlayingFirst() -> Bool {
		   return self.player.isPlayingFirst()
	   }
	
	/// Starts to play music
	func playSong() {
		return self.player.playSong()
	}
	
	/// Pauses the music
	func pauseSong() {
		return self.player.pauseSong()
	}
	
	/// Gets the name of the artist being played now
	/// - Returns: Name of the artist
	func nowPlayingArtist() -> String? {
		return self.player.nowPlayingArtist()
	}
	
	/// Gets the title of the album for the music being played now
	/// - Returns: Title of the album
	func nowPlayingAlbumTitle() -> String? {
		return self.player.nowPlayingAlbumTitle()
	}
	
	/// Gets the title of the song being played now
	/// - Returns: Title of the song
	func nowPlayingTitle() -> String? {
		return self.player.nowPlayingTitle()
	}
	
	/// Gets the artwork of the song being played now
	/// - Returns: Artwork of the song
	func nowPlayingArtwork() -> MPMediaItemArtwork? {
		return self.player.nowPlayingArtwork()
	}
	
	/// Indicates if the player is on shuffle mode or not
	/// - Returns: true if yes, false if not
	func isShuffleOn() -> Bool {
		return self.player.isShuffleOn()
	}
	
	/// Gets the playback time of the song being played now
	/// - Returns: Song's playback time
	func nowPlayingPlaybackTime() -> TimeInterval {
		return self.player.nowPlayingPlaybackTime()
	}
	
	/// Gets the time duration of the song being played now
	/// - Returns: Song's duration
	func nowPlayingDuration() -> TimeInterval {
		return self.player.nowPlayingDuration()
	}
	
	/// Tells the player to play the previous song
	func playPrevious() {
		self.player.playPrevious()
	}
	
	/// Tells the player to play the next song
	func playNext() {
		self.player.playNext()
	}
	
	/// Gets the app status
	/// - Returns: App status
	func appStatus() -> AppStatus {
		return self.app.getAppStatus()
	}
}

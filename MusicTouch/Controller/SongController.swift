//
//  SongController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import Combine

class SongController {
	
	private var tabBarController: UITabBarController?
	private var songList: [MTSongData] = [] {
		didSet {
			dataUpdatedSubject.send()
		}
	}
	private var songsRetriever: SongsRetrieverProtocol?
	private var dataStore: DataStoreProtocol
	private var player: PlayerProtocol
	
	var dataUpdatedSubject = PassthroughSubject<Void, Never>()

	init(tabBarController: UITabBarController, dataStore: DataStoreProtocol, player: PlayerProtocol) {
		self.tabBarController = tabBarController
		self.dataStore        = dataStore
		self.player           = player
		
		self.configureByDefault()
	}
	
    /// Shows the player view and start playing all the listed artists songs
    ///
    /// - Parameter shuffle: start playing in shuffle mode (true) or in queue mode (false)
	func startToPlay(shuffle: Bool, index: Int) {
		
		guard let retriever = self.songsRetriever else { return }
        
		// Use the songsRetriever object to read the songs from the Media Library.
		self.player.setCollection(retriever.songsCollection())
        
        if (shuffle) {
            self.player.shuffleModeOn()
        }
        else {
            self.player.shuffleModeOff()
        }
        
        // If an index has been informed, get the nth song from the data-store list
        if (index >= 0) {
            self.player.setSong(self.songList[index].mediaItem)
        }
		        
        // Start playing the first song and, also, transition to the Play view
        if let vc = tabBarController?.customizableViewControllers?[TabBarItem.play.rawValue] as? PlayViewController {
            vc.playSong()
            tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
            tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
        }

	}
	
	func getItem(byIndex: Int) -> MTSongData? {
		guard (self.indexWithinBounds(index: byIndex)) else { return nil }
		
		return self.songList[byIndex]
	}
	
	func indexWithinBounds(index: Int) -> Bool {
		return index < self.numberOfItems()
	}
	
	func numberOfItems() -> Int {
		return self.songList.count
	}
	
	private func initializeList() {
		self.setSongsList(self.dataStore.songList())
	}

    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setSongsList(_ list: [MTSongData]) {
        self.songList = list
    }
	
	func isDataLoaded() -> Bool {
		return self.dataStore.isDataLoaded()
	}

	func configure(songs: [MTSongData], songsRetriever: SongsRetrieverProtocol) {
		self.setSongsList(songs)

		self.songsRetriever = songsRetriever
	}
	
	func configureByDefault() {
		self.configure(songs: self.dataStore.songList(), songsRetriever: self)
	}
	
}

extension SongController: SongsRetrieverProtocol {
	func songsCollection() -> MPMediaItemCollection {
		// By default, retrieves the list of all existing songs in the Media Library
		return MPMediaItemCollection(items: self.dataStore.getSongsList())
	}
}

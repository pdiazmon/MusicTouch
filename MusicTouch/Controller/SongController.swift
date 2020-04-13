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

class SongController {
	
	private let app = UIApplication.shared.delegate as! AppDelegate
	
	var tabBarController: UITabBarController?
	var songList: [MTSongData] = []
	weak var viewController: SongViewController?
	private var songsRetriever: SongsRetrieverProtocol?
	
	init(tabBarController: UITabBarController, viewController: SongViewController) {
		self.tabBarController = tabBarController
		self.viewController   = viewController
	}
	
    /// Shows the player view and start playing all the listed artists songs
    ///
    /// - Parameter shuffle: start playing in shuffle mode (true) or in queue mode (false)
	func startToPlay(shuffle: Bool, index: Int) {
		
		guard let retriever = self.songsRetriever else { return }
        
		// Use the songsRetriever object to read the songs from the Media Library.
		app.appPlayer.setCollection(retriever.songsCollection())
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        // If an index has been informed, get the nth song from the data-store list
        if (index >= 0) {
            app.appPlayer.setSong(self.songList[index].mediaItem)
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
	
	func initializeList() {
		self.setSongsList(self.app.dataStore.songList())
	}

    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setSongsList(_ list: [MTSongData]) {
        self.songList = list
        viewController?.reloadData()
    }
	
	func isDataLoaded() -> Bool {
		return self.app.dataStore.isDataLoaded()
	}

	func configure(songs: [MTSongData], songsRetriever: SongsRetrieverProtocol) {
		self.setSongsList(songs)

		self.songsRetriever = songsRetriever
	}
	
	func configureByDefault() {
		self.configure(songs: self.app.dataStore.songList(), songsRetriever: self)
	}
	
}

extension SongController: SongsRetrieverProtocol {
	func songsCollection() -> MPMediaItemCollection {
		// By default, retrieves the list of all existing songs in the Media Library
		return MPMediaItemCollection(items: app.dataStore.getSongsList())
	}
}
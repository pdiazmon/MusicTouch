//
//  PlaylistController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import Combine

class PlaylistController {
	
	private var tabBarController: UITabBarController?
	private var playlistList: [MTPlaylistData] = [] {
		didSet {
			dataUpdatedSubject.send()
		}
	}
	private var dataStore: DataStoreProtocol
	private var player: PlayerProtocol?
	
	var dataUpdatedSubject = PassthroughSubject<Void, Never>()
	
	init(tabBarController: UITabBarController?, dataStore: DataStoreProtocol, player: PlayerProtocol?) {
		self.tabBarController = tabBarController
		self.dataStore        = dataStore
		self.player           = player
		
		self.initializeList()
	}
	
    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setPlaylistList(_ list: [MTPlaylistData]) {
        self.playlistList = list
    }
	
	/// Sets the playlist list with the default values
	private func initializeList() {
		self.setPlaylistList(self.dataStore.playlistList())
	}
	
	/// Gets the n-th item of the playlist list
	/// - Parameter byIndex: Item index
	/// - Returns: An MTPlaylistData object of the n-th playlist
	func getItem(byIndex: Int) -> MTPlaylistData? {
		guard (self.indexWithinBounds(index: byIndex)) else { return nil }
		
		return self.playlistList[byIndex]
	}
	
	/// Indicates if the given index is within the bounds of the playlist list
	/// - Parameter index: Index to check
	/// - Returns: true if the index is within bounds and false if not
	func indexWithinBounds(index: Int) -> Bool {
		return index < self.numberOfItems()
	}
	
	/// Gets the number of elements in the playlist list
	/// - Returns: The number of items in the playlist list
	func numberOfItems() -> Int {
		return self.playlistList.count
	}
	
	/// Shows the songs view for an specific playlist
	/// - Parameter itemIndex: Index of the playlist in the list
	func showSongsView(itemIndex: Int) {
        // Get the SongViewController, make it to reload its table and activate it
        if let vc = tabBarController?.customizableViewControllers?[TabBarItem.song.rawValue] as? SongViewController,
			let item = getItem(byIndex: itemIndex),
			let songController = vc.controller
		{
			songController.configure(songs: item.songs, songsRetriever: item)
            tabBarController?.selectedIndex = TabBarItem.song.rawValue
        }
	}
	
    /// Handles the swipe event over a cell
    ///
    /// - Parameters:
    ///   - indexPath: Swiped cell index
    ///   - shuffle: true if shuffle mode has been selected, false in other case
    func swipeHandler(indexPath: IndexPath, shuffle: Bool) {
        
        guard let item = self.getItem(byIndex: indexPath.row) else { return }
		guard let player = self.player else { return }
        
        // Set the player collection
		player.setCollection(item.songsCollection())
        
        // Sets the shuffle mode
        if (shuffle) {
            player.shuffleModeOn()
        }
        else {
            player.shuffleModeOff()
        }
        
        // Wait and start playing the first song and, also, transition to the Play view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let vc = self.tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
                vc.playSong()

                self.tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
                self.tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
            }
        }
    }

}

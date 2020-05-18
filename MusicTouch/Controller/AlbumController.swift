//
//  AlbumController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import Combine

class AlbumController {
	
	private var tabBarController: UITabBarController?
	private var albumList: [MTAlbumData] = [] {
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
	
    /// Shows the player view and start playing all the listed artists songs
    ///
    /// - Parameter shuffle: start playing in shuffle mode (true) or in queue mode (false)
    func startToPlay(shuffle: Bool) {
		
		guard let player = self.player else { return }
        
        // Set the player collection
		player.setCollection(MPMediaItemCollection(items: self.dataStore.getSongsList()))
        
        if (shuffle) {
			player.shuffleModeOn()
        }
        else {
			player.shuffleModeOff()
        }
        
        // Start playing the first song and, also, transition to the Play view
        if let vc = tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
            vc.playSong()
			
			showSongsView()
        }
        
    }
	
	/// Gets the n-th item of the album list
	/// - Parameter byIndex: Item index
	/// - Returns: An MTAlbumData object of the n-th album
	func getItem(byIndex: Int) -> MTAlbumData? {
		guard (self.indexWithinBounds(index: byIndex)) else { return nil }
		
		return self.albumList[byIndex]
	}
	
	/// Gets the number of elements in the album list
	/// - Returns: The number of items in the album list
	func indexWithinBounds(index: Int) -> Bool {
		return index < self.numberOfItems()
	}
	
	/// Gets the number of elements in the album list
	/// - Returns: The number of items in the album list
	func numberOfItems() -> Int {
		return self.albumList.count
	}

	/// Shows the songs view for an specific album
	/// - Parameter itemIndex: Index of the album in the list
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
	
	/// Shows the songs view
	func showSongsView() {
		tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
		tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
	}
	
    /// Handles the swipe event over a cell
    ///
    /// - Parameters:
    ///   - indexPath: Swiped cell index
    ///   - shuffle: true if shuffle mode has been selected, false in other case
    func swipeHandler(indexPath: IndexPath, shuffle: Bool) {
        
		guard let item = self.getItem(byIndex: indexPath.row) else { return }
		guard let player = self.player else { return }
        
        // Set the player collection from the songlist
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
            
            if let vc = self.tabBarController?.customizableViewControllers?[TabBarItem.play.rawValue] as? PlayViewController {
                vc.playSong()

                self.tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
                self.tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
            }
        }
    }

	/// Sets the album list with the default values
	private func initializeList() {
		self.setAlbumList(self.dataStore.albumList())
	}
	
	/// Configure the AlbumController with default values
	func configureByDefault() {
		self.initializeList()
	}

    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setAlbumList(_ list: [MTAlbumData]) {
        self.albumList = list
    }
	
}

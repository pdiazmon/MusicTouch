//
//  PlaylistController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit

class PlaylistController {
	
	private let app = UIApplication.shared.delegate as! AppDelegate
	
	var tabBarController: UITabBarController?
	var playlistList: [MTPlaylistData] = []
	weak var viewController: PlaylistViewController?
	
	init(tabBarController: UITabBarController, viewController: PlaylistViewController) {
		self.tabBarController = tabBarController
		self.viewController   = viewController
	}
	
    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setPlaylistList(_ list: [MTPlaylistData]) {
        self.playlistList = list
        viewController?.reloadData()
    }
	
	func initializeList() {
		self.setPlaylistList(self.app.dataStore.playlistList())
	}
	
	func isDataLoaded() -> Bool {
		return self.app.dataStore.isDataLoaded()
	}
	
	func getItem(byIndex: Int) -> MTPlaylistData? {
		guard (self.indexWithinBounds(index: byIndex)) else { return nil }
		
		return self.playlistList[byIndex]
	}
	
	func indexWithinBounds(index: Int) -> Bool {
		return index < self.numberOfItems()
	}
	
	func numberOfItems() -> Int {
		return self.playlistList.count
	}
	
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
        
        // Set the player collection
		app.appPlayer.setCollection(item.songsCollection())
        
        // Sets the shuffle mode
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
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

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

class AlbumController {
	
	private let app = UIApplication.shared.delegate as! AppDelegate
	
	var tabBarController: UITabBarController?
	var albumList: [MTAlbumData] = []
	weak var viewController: AlbumViewController?
	
	init(tabBarController: UITabBarController, viewController: AlbumViewController) {
		self.tabBarController = tabBarController
		self.viewController   = viewController
	}
	
    /// Shows the player view and start playing all the listed artists songs
    ///
    /// - Parameter shuffle: start playing in shuffle mode (true) or in queue mode (false)
    func startToPlay(shuffle: Bool) {
        
        // Set the player collection
		app.appPlayer.setCollection(MPMediaItemCollection(items: app.dataStore.getSongsList()))
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        // Start playing the first song and, also, transition to the Play view
        if let vc = tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
            vc.playSong()
			
			showSongsView()
        }
        
    }
	
	func getItem(byIndex: Int) -> MTAlbumData? {
		guard (self.indexWithinBounds(index: byIndex)) else { return nil }
		
		return self.albumList[byIndex]
	}
	
	func indexWithinBounds(index: Int) -> Bool {
		return index < self.numberOfItems()
	}
	
	func numberOfItems() -> Int {
		return self.albumList.count
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
        
        // Set the player collection from the songlist
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
            
            if let vc = self.tabBarController?.customizableViewControllers?[TabBarItem.play.rawValue] as? PlayViewController {
                vc.playSong()

                self.tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
                self.tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
            }
        }
    }

	func initializeList() {
		self.setAlbumList(self.app.dataStore.albumList())
	}

    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setAlbumList(_ list: [MTAlbumData]) {
        self.albumList = list
        viewController?.reloadData()
    }
	
	func isDataLoaded() -> Bool {
		return self.app.dataStore.isDataLoaded()
	}

}

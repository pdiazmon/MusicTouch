//
//  ArtistController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class ArtistController {
	
	private let app = UIApplication.shared.delegate as! AppDelegate
	
	var tabBarController: UITabBarController?
	var artistList: [MTArtistData] = []
	weak var viewController: ArtistViewController?
	
	init(tabBarController: UITabBarController, viewController: ArtistViewController) {
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
	
	func getItem(byIndex: Int) -> MTArtistData? {
		guard (self.indexWithinBounds(index: byIndex)) else { return nil }
		
		return self.artistList[byIndex]
	}
	
	func indexWithinBounds(index: Int) -> Bool {
		return index < self.numberOfItems()
	}
	
	func numberOfItems() -> Int {
		return self.artistList.count
	}

	func showAlbumsView(itemIndex: Int) {
        if let vc = tabBarController?.customizableViewControllers?[TabBarItem.album.rawValue] as? AlbumViewController,
		   let controller = vc.controller,
		   let item = getItem(byIndex: itemIndex) {
				controller.setAlbumList(item.albums)
				tabBarController?.selectedIndex = TabBarItem.album.rawValue
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
		self.setArtistList(self.app.dataStore.artistList())
	}

    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setArtistList(_ list: [MTArtistData]) {
        self.artistList = list
        viewController?.reloadData()
    }

}

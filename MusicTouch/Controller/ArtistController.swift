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
import Combine

class ArtistController {
	
	private var tabBarController: UITabBarController?
	private var artistList: [MTArtistData] = [] {
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

	private func initializeList() {
		self.setArtistList(self.dataStore.artistList())
	}

    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setArtistList(_ list: [MTArtistData]) {
        self.artistList = list
    }

}

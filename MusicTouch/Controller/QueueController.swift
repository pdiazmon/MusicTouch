//
//  QueueController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 13/04/2020.
//  Copyright © 2020 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class QueueController {
	private weak var viewController: QueueViewController?
	private var player: PlayerProtocol

	init(viewController: QueueViewController, player: PlayerProtocol, backgroundColor: UIColor) {
		self.viewController                  = viewController
		self.player                          = player
		self.viewController?.backgroundColor = backgroundColor
	}
	
	/// Gets the n-th item of the player's current playing list
	/// - Parameter byIndex: Index of the item
	/// - Returns: Song item
	func getItem(byIndex: Int) -> MPMediaItem? {
		return self.player.getCollection().items[byIndex]
	}
	
	/// Gets the number of songs of the player's current playing list
	/// - Returns: Number of items
	func numberOfItems() -> Int {
		return self.player.getCollection().items.count
	}
	
	/// Configures the QueueController
	/// - Parameter backgroundColor: Background color of the View
	func configure(backgroundColor: UIColor) {
		self.viewController?.backgroundColor = backgroundColor
	}
	
	/// Gets the music player object
	/// - Returns: Player object
	func getPlayer() -> PlayerProtocol {
		return self.player
	}

}

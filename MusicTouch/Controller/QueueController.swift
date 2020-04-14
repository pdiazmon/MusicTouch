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
	
	func getItem(byIndex: Int) -> MPMediaItem? {
		return self.player.getCollection().items[byIndex]
	}
	
	func numberOfItems() -> Int {
		return self.player.getCollection().items.count
	}
	
	func configure(backgroundColor: UIColor) {
		self.viewController?.backgroundColor = backgroundColor
	}

}

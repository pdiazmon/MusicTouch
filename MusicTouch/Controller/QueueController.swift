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
	private var app = UIApplication.shared.delegate as! AppDelegate
	
	weak var viewController: QueueViewController?

	init(viewController: QueueViewController) {
		self.viewController = viewController
	}
	
	func getItem(byIndex: Int) -> MPMediaItem? {
		return app.appPlayer.getCollection().items[byIndex]
	}
	
	func numberOfItems() -> Int {
		return app.appPlayer.getCollection().items.count
	}

}

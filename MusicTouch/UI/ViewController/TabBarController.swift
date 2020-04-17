//
//  TabBarController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore
	private let player    = (UIApplication.shared.delegate as! AppDelegate).appPlayer

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
		
		for view in self.customizableViewControllers! {
			if (view is PlaylistViewController) {
				let vc = (view as! PlaylistViewController)
				
				vc.controller = PlaylistController(tabBarController: self, viewController: vc, dataStore: self.dataStore, player: self.player)
			}
			else if (view is ArtistViewController) {
				let vc = (view as! ArtistViewController)
				
				vc.controller = ArtistController(tabBarController: self, viewController: vc, dataStore: self.dataStore, player: self.player)
			}
			else if (view is AlbumViewController) {
				let vc = (view as! AlbumViewController)
				
				vc.controller = AlbumController(tabBarController: self, viewController: vc, dataStore: self.dataStore, player: self.player)
			}
			else if (view is SongViewController) {
				let vc = (view as! SongViewController)
				
				vc.controller = SongController(tabBarController: self, viewController: vc, dataStore: self.dataStore, player: self.player)
			}
			else if (view is PlayViewController) {
				let vc = (view as! PlayViewController)
				let thisApp: AppDelegate = UIApplication.shared.delegate as! AppDelegate
				
				vc.controller = PlayController(tabBarController: self, viewController: vc, player: self.player, app: thisApp)
			}
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return (customizableViewControllers?[selectedIndex] != viewController)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        // If the Album button has been clicked
        if (viewController is AlbumViewController) {
            // .. prepare the AlbumViewController to show all the existing albums
			if let vc = (viewController as? AlbumViewController), let controller = vc.controller {
				controller.configureByDefault()
			}
        }
        // If the Song button has been clicked
        else if (viewController is SongViewController) {
            // .. prepare the SongViewController to show all the existing songs
			if let vc = (viewController as? SongViewController), let controller = vc.controller {
				controller.configureByDefault()
			}
        }

    }
}

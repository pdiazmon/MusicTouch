//
//  TabBarController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class TabBarController: UITabBarController {
    
    private let dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
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
            (viewController as! AlbumViewController).setAlbumList([])
        }
        // If the Song button has been clicked
        else if (viewController is SongViewController) {
            // .. prepare the SongViewController to show all the existing songs
            (viewController as! SongViewController).setSongList([])
        }

    }
}

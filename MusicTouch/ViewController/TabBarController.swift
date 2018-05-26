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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // If the Album button has been clicked
        if (viewController is AlbumViewController) {
            // Store all the albums from the music library into the data-store
            self.dataStore.refreshAlbumList(byArtist: "")
            // Reload the albums view data table
            (viewController as! AlbumViewController).reload()
        }
        // If the Song button has been clicked
        else if (viewController is SongViewController) {
            // Store all the songs from the music library into the data-store
            self.dataStore.refreshSongList(byArtist: "", byAlbum: "")
            // Reload the songs view data table
            (viewController as! SongViewController).reload()
        }
    }
}

//
//  TabBarController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore

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

extension TabBarController {
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (viewController is AlbumViewController) {
            self.dataStore.refreshAlbumList(byArtist: "")
            (viewController as! AlbumViewController).reload()
        }
        else if (viewController is SongViewController) {
            self.dataStore.refreshSongList(byArtist: "", byAlbum: "")
            (viewController as! SongViewController).reload()
        }
    }
}

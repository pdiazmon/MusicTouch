//
//  PlaylistViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer
import NVActivityIndicatorView

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    private let app = UIApplication.shared.delegate as! AppDelegate
    private var playlistList: [MTPlaylistData] = []

    override var prefersStatusBarHidden: Bool { return true }
    
    var activity: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // create an activity animation
        activity = NVActivityIndicatorViewFactory.shared.getNewLoading(frame: self.playlistTableView.frame)
        self.view.addSubview(activity)
        activity.startAnimating()
        
        
        // Register the correct CellView class
        self.playlistTableView.register(MTCellFactory.shared.classForCoder(), forCellReuseIdentifier: "CellPlaylist")
        
        //self.playlistTableView.backgroundColor = UIColor.lightGray
		self.playlistTableView.backgroundColor = UIColor.systemBackground
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: UITableViewDataSource
extension PlaylistViewController: UITableViewDataSource {
    
    /// Datasource handler for tableview new cells creating
    ///
    /// - Parameters:
    ///   - tableView: TableView itself
    ///   - indexPath: Index of the new cell
    /// - Returns: The new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Request to the tableview for a new cell by its identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellPlaylist") as! MTCell
        
        // Get the nth item from the data-source playlist list
        let item = self.playlistList[indexPath.row]

        // Create the delegate
        if (cell.delegate == nil) { cell.delegate = MTPlaylistCell() }
        
        // Render the new cell with the item information
        MTCellFactory.shared.render(cell: cell, item: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    /// Datasource handler for tableview number of cells
    ///
    /// - Parameters:
    ///   - tableView: TableView itself
    ///   - section: Section identifier within the TableView
    /// - Returns: Number of cells in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistList.count
    }
    
}


// MARK: UITableViewDelegate
extension PlaylistViewController: UITableViewDelegate {

    /// Delegate handler for cell selection event in a TableView
    ///
    /// - Parameters:
    ///   - tableView: The TableView itself
    ///   - indexPath: Selected cell index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (indexPath.row < self.playlistList.count) else { return }

        // Extract the item from the data-store object with the selected cell index
        let item = self.playlistList[indexPath.row]
        
        // Get the SongViewController, make it to reload its table and activate it
        if let vc = tabBarController?.customizableViewControllers?[TabBarItem.song.rawValue] as? SongViewController {
            vc.setSongList(item.songs)
            tabBarController?.selectedIndex = TabBarItem.song.rawValue
        }
    }
    
    /// Delegate handler for leading swipe event in a TableView cell
    ///
    /// - Parameters:
    ///   - tableView: The TableView itself
    ///   - indexPath: Swiped cell index
    /// - Returns: A 'shuffle' action configuration
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard (indexPath.row < self.playlistList.count) else { return UISwipeActionsConfiguration(actions: []) }
        
        // Create the contextual action
        let shuffleAction = UIContextualAction(style: .normal, title:  "Shuffle", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            self.swipeHandlerAux(indexPath: indexPath, shuffle: true)
            
            success(true)
        })
        
        shuffleAction.image           = UIImage(named: "shuffle")
        shuffleAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [shuffleAction])
    }
    
    /// Delegate handler for trailing swipe event in a TableView cell
    ///
    /// - Parameters:
    ///   - tableView: The TableView itself
    ///   - indexPath: Swiped cell index
    /// - Returns: A 'play' action configuration
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        guard (indexPath.row < self.playlistList.count) else { return UISwipeActionsConfiguration(actions: []) }
        
        // Create the contextual action
        let playAction = UIContextualAction(style: .normal, title:  "Play", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            self.swipeHandlerAux(indexPath: indexPath, shuffle: false)
            
            success(true)
        })
        
        playAction.image           = UIImage(named: "playall")
        playAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [playAction])
    }
}

extension PlaylistViewController {
    
    /// Handles the swipe event over a cell
    ///
    /// - Parameters:
    ///   - indexPath: Swiped cell index
    ///   - shuffle: true if shuffle mode has been selected, false in other case
    private func swipeHandlerAux(indexPath: IndexPath, shuffle: Bool) {
        
        guard (indexPath.row < self.playlistList.count) else { return }
        
        // Get the selected playlist
        let item = self.playlistList[indexPath.row]
        
        // Set the player collection
        app.appPlayer.setCollection(MPMediaItemCollection(items: item.songs.map { $0.mediaItem } ))
        
        // Sets the shuffle mode
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        // Wait and start playing the first song and, also, transition to the Play view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let vc = self.tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
                vc.playSong()

                self.tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
                self.tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
            }
        }
    }

}

extension PlaylistViewController {
    
    /// Set the playlists list to be shown
    ///
    /// - Parameter list: playlists list
    func setPlaylistList(_ list: [MTPlaylistData]) {
        self.playlistList = list
        self.playlistTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
        if (self.app.dataStore.isDataLoaded() && self.playlistList.count == 0) {
            self.setPlaylistList(self.app.dataStore.playlistList())
            
            if (self.activity.isAnimating) {
                self.activity.stopAnimating()
                self.activity.removeFromSuperview()
            }
        }
        else if (!self.app.dataStore.isDataLoaded()) {
            
            // Asynchronously, in background, load the playlist data
            DispatchQueue.main.async {
                
                // Load all the playlist data
                if (self.playlistList.count == 0) {
                    self.setPlaylistList(self.app.dataStore.playlistList())
                }
                
                // stop the animation
                if (self.activity.isAnimating) {
                    self.activity.stopAnimating()
                    self.activity.removeFromSuperview()
                }
            }
        }
    }

}



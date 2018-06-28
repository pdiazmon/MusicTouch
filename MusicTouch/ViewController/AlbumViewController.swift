//
//  SecondViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var playButtonsStack: UIStackView!
    
    private var app       = UIApplication.shared.delegate as! AppDelegate
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        layout()
        
        // Register the correct CellView class
        self.albumsTableView.register(MTCellFactory.shared.classForCoder(), forCellReuseIdentifier: "CellAlbum")
        
        self.albumsTableView.backgroundColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Play all button press event handler
    ///
    /// - Parameter sender: button itself
    @IBAction func playAllPressed(_ sender: UIButton) {
        startToPlay(shuffle: false)
    }
    
    /// Shffle button press event handler
    ///
    /// - Parameter sender: button itself
    @IBAction func shufflePressed(_ sender: UIButton) {
        startToPlay(shuffle: true)
    }
    
    /// Shows the player view and start playing all the listed albums songs
    ///
    /// - Parameter shuffle: start playing in shuffle mode (true) or in queue mode (false)
    private func startToPlay(shuffle: Bool) {
        
        // Refresh the data-store song list from the music library
        app.dataStore.refreshSongListFromAlbumList()
        
        // Set the player collection from the datastore songlist
        app.appPlayer.setCollection(app.dataStore.songCollection())
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        // Start playing the first song and, also, transition to the Play view
       if let vc = tabBarController?.customizableViewControllers?[TabBarItem.play.rawValue] as? PlayViewController {
            vc.playSong()
            tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
            tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
        }
    }
}

// MARK: UITableViewDataSource
extension AlbumViewController: UITableViewDataSource {
    
    /// Datasource handler for tableview new cells creating
    ///
    /// - Parameters:
    ///   - tableView: TableView itself
    ///   - indexPath: Index of the new cell
    /// - Returns: The new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Request to the tableview for a new cell by its identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAlbum") as! MTCell
        
        // Get the nth item from the data-store album list
        let item = app.dataStore.albumList()[indexPath.row]
        
        // Create the delegate
        if (cell.delegate == nil) { cell.delegate = MTAlbumCell() }
        
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
        return app.dataStore.albumList().count
    }
}


// MARK: UITableViewDelegate
extension AlbumViewController: UITableViewDelegate {
    
    /// Delegate handler for cell selection event in a TableView
    ///
    /// - Parameters:
    ///   - tableView: The TableView itself
    ///   - indexPath: Selected cell index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard (indexPath.row < app.dataStore.albumList().count) else { return }
        
        // Extract the item from the data-store object with the selected cell index
        let item = app.dataStore.albumList()[indexPath.row]
        
        // Refresh the data-store songlist, filtering by artist name and album title
        app.dataStore.refreshSongList(byArtist: item.artistName, byAlbum: item.albumTitle)
        
        // Get the SongViewController, make it to reload its table and activate it
        if let vc = tabBarController?.customizableViewControllers?[TabBarItem.song.rawValue] as? SongViewController {
            vc.reload()
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

        guard (indexPath.row < app.dataStore.albumList().count) else { return UISwipeActionsConfiguration(actions: []) }

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
        guard (indexPath.row < app.dataStore.albumList().count) else { return UISwipeActionsConfiguration(actions: []) }

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


extension AlbumViewController {
    
    /// Forces the TableView to reload its data
    public func reload() {
        if let tv = self.albumsTableView {
            tv.reloadData()
            layout()
        }
    }
    
    /// Enable/disable play buttons depending on list emptyness
    func layout() {
        for button in self.playButtonsStack.arrangedSubviews {
            if let button = (button as? UIButton) {
                button.isEnabled = app.dataStore.albumList().count > 0
            }
        }
    }
    
    /// Handles the swipe event over a cell
    ///
    /// - Parameters:
    ///   - indexPath: Swiped cell index
    ///   - shuffle: true if shuffle mode has been selected, false in other case
    func swipeHandlerAux(indexPath: IndexPath, shuffle: Bool) {
        
        guard (indexPath.row < app.dataStore.albumList().count) else { return }
        
        // Get the selected album
        let item = app.dataStore.albumList()[indexPath.row]
        
        // Refresh the data-store song list from the music library filtering by artist name and album title
        app.dataStore.refreshSongList(byArtist: item.artistName, byAlbum: item.albumTitle)
        
        // Set the player collection from the datastore songlist
        app.appPlayer.setCollection(app.dataStore.songCollection())
        
        // Sets the shuffle mode
        if (shuffle) {
            self.app.appPlayer.shuffleModeOn()
        }
        else {
            self.app.appPlayer.shuffleModeOff()
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
}


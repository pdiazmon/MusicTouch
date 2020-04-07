//
//  SongViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer
import NVActivityIndicatorView


class SongViewController: UIViewController {

    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var playButtonsStack: UIStackView!
    
    private let app = UIApplication.shared.delegate as! AppDelegate
    
    private var songList: [MTSongData] = []

    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
        // Register the correct CellView class
        self.songsTableView.register(MTCellFactory.shared.classForCoder(), forCellReuseIdentifier: "CellSong")
        
		self.songsTableView.backgroundColor = UIColor.systemBackground
        
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
    @IBAction func shufflePressed(_ sender: Any) {
        startToPlay(shuffle: true)
    }
    
    /// Shows the player view and start playing all the listed albums songs
    ///
    /// - Parameter shuffle: start playing in shuffle mode (true) or in queue mode (false)
    /// - Parameter index: (Optional) Index of the song to be played in the TableView
    private func startToPlay(shuffle: Bool,  index: Int = -1) {
        
        // Set the player collection from the datastore songlist
        app.appPlayer.setCollection(MPMediaItemCollection(items: self.songList.map { $0.mediaItem }))
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        // If an index has been informed, get the nth song from the data-store list
        if (index >= 0) {
            app.appPlayer.setSong(self.songList[index].mediaItem)
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
extension SongViewController: UITableViewDataSource {
    
    /// Datasource handler for tableview new cells creating
    ///
    /// - Parameters:
    ///   - tableView: TableView itself
    ///   - indexPath: Index of the new cell
    /// - Returns: The new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Request to the tableview for a new cell by its identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSong") as! MTCell
        
        // Get the nth item from the album list
        let item = self.songList[indexPath.row]
        
        // Create the delegate
        if (cell.delegate == nil) { cell.delegate = MTSongCell() }
        
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
        return self.songList.count
    }
}

// MARK: UITableViewDelegate
extension SongViewController: UITableViewDelegate {
    
    /// Delegate handler for cell selection event in a TableView
    ///
    /// - Parameters:
    ///   - tableView: The TableView itself
    ///   - indexPath: Selected cell index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startToPlay(shuffle: false, index: indexPath.row)
    }
}

// MARK: Activity animation

extension SongViewController {
    
    /// Forces the TableView to reload its data
    public func reload() {
        self.songsTableView?.reloadData()
        layout()
    }
    
    /// Enable/disable play buttons depending on list emptyness
    func layout() {
        if let stack = self.playButtonsStack {
            for button in stack.arrangedSubviews {
                if let button = (button as? UIButton) {
                    button.isEnabled = self.songList.count > 0
                }
            }
        }
    }
    
    /// Set the song list to be displayed in the view
    ///
    /// - Parameter songs: List of songs
    func setSongList(_ songs: [MTSongData]) {
        self.songList = songs
        self.reload()
    }
    
    /// The ViewController has just appeared on screen. Load its data.
    ///
    /// - Parameter animated: If true, the view was added to the window using an animation.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (self.app.dataStore.isDataLoaded() && self.songList.count == 0) {
            self.setSongList(self.app.dataStore.songList())
        }
        else if (!self.app.dataStore.isDataLoaded()) {

            // create an activity animation
            let activity = NVActivityIndicatorViewFactory.shared.getNewLoading(frame: self.songsTableView.frame)
            
            self.view.addSubview(activity)
            activity.startAnimating()
            
            // Asynchronously, in background, load the albums data
            DispatchQueue.main.async {
                
                if (self.songList.count == 0) {
                    self.setSongList(self.app.dataStore.songList())
                }
                
                // stop the animation
                activity.stopAnimating()
                activity.removeFromSuperview()
            }
        }
        
    }
    
}



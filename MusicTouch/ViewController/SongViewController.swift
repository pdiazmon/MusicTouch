//
//  SongViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {

    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var playButtonsStack: UIStackView!
    
    private let app = UIApplication.shared.delegate as! AppDelegate
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
        // Register the correct CellView class
        self.songsTableView.register(MTCell.classForCoder(), forCellReuseIdentifier: "CellSong")
        
        self.songsTableView.backgroundColor = UIColor.gray
        
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
        app.appPlayer.setCollection(app.dataStore.songCollection())
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        // If an index has been informed, get the nth song from the data-store list
        if (index >= 0) {
            app.appPlayer.setSong(app.dataStore.songList()[index].mediaItem)
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
        
        // Get the nth item from the data-store album list
        let item = app.dataStore.songList()[indexPath.row]
        
        // Create the delegate
        cell.delegate = MTSongCell()
        
        // Render the new cell with the item information
        cell.render(item: item)
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
        return app.dataStore.songList().count
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
                    button.isEnabled = app.dataStore.songList().count > 0
                }
            }
        }
    }
}


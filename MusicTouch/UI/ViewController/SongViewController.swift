//
//  SongViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer
import UIFontComplete
import Combine


class SongViewController: UIViewController {

    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var playButtonsStack: UIStackView!
    
	var controller: SongController?
	var controllerDataUpdate: Cancellable?

    override var prefersStatusBarHidden: Bool { return true }
	
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        
        // Register the correct CellView class
        self.songsTableView.register(MTCellFactory.shared.classForCoder(), forCellReuseIdentifier: "CellSong")
        
		self.songsTableView.backgroundColor = UIColor.systemBackground
		
		controllerDataUpdate = controller?.dataUpdatedSubject.sink { [weak self] in
			self?.reloadData()
		}
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
		
		guard let controller = self.controller else { return }

		controller.startToPlay(shuffle: shuffle, index: index)
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
		guard let controller = self.controller,
			  let item = controller.getItem(byIndex: indexPath.row)
		else { return cell }
        
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
		guard let controller = self.controller else { return 0 }
		
		return controller.numberOfItems()
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
		self.startToPlay(shuffle: false, index: indexPath.row)
    }
}

// MARK: Activity animation

extension SongViewController {
    
    /// Forces the TableView to reload its data
    private func reloadData() {
        self.songsTableView?.reloadData()
        layout()
    }
    
    /// Organizes the view layout
    private func layout() {
		if let stack = self.playButtonsStack, let controller = self.controller {
            for button in stack.arrangedSubviews {
                if let button = (button as? UIButton) {
					button.isEnabled = (controller.numberOfItems() > 0)
                }
            }
        }
    }
    
    /// The ViewController has just appeared on screen. Load its data.
    ///
    /// - Parameter animated: If true, the view was added to the window using an animation.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
}

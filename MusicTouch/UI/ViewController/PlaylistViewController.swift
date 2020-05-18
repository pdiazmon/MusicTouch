//
//  PlaylistViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import Combine

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistTableView: UITableView!
	
	var controller: PlaylistController?
	var controllerDataUpdate: Cancellable?
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the correct CellView class
        self.playlistTableView.register(MTCellFactory.shared.classForCoder(), forCellReuseIdentifier: "CellPlaylist")
        
		self.playlistTableView.backgroundColor = UIColor.systemBackground
		
		controllerDataUpdate = controller?.dataUpdatedSubject.sink { [weak self] in
			self?.reloadData()
		}
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
		guard let controller = self.controller,
			  let item = controller.getItem(byIndex: indexPath.row)
		else { return cell }

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
		guard let controller = self.controller else { return 0 }
		
		return controller.numberOfItems()
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
		
		guard let controller = self.controller else { return }
        
		controller.showSongsView(itemIndex: indexPath.row)
    }
    
    /// Delegate handler for leading swipe event in a TableView cell
    ///
    /// - Parameters:
    ///   - tableView: The TableView itself
    ///   - indexPath: Swiped cell index
    /// - Returns: A 'shuffle' action configuration
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
		guard let controller = self.controller,
			  controller.indexWithinBounds(index: indexPath.row)
		else { return UISwipeActionsConfiguration(actions: []) }
        
        // Create the contextual action
        let shuffleAction = UIContextualAction(style: .normal, title:  "Shuffle", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
			controller.swipeHandler(indexPath: indexPath, shuffle: true)
            
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
		guard let controller = self.controller,
		 	  controller.indexWithinBounds(index: indexPath.row)
		else { return UISwipeActionsConfiguration(actions: []) }
        
        // Create the contextual action
        let playAction = UIContextualAction(style: .normal, title:  "Play", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
			controller.swipeHandler(indexPath: indexPath, shuffle: false)
            
            success(true)
        })
        
        playAction.image           = UIImage(named: "playall")
        playAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [playAction])
    }
}

extension PlaylistViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)		
    }
	
	/// Forces the tableview to reload its data
	private func reloadData() {
		guard let _ = self.playlistTableView else { return }
		
		self.playlistTableView.reloadData()
	}

}



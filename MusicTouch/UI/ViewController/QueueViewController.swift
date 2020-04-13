//
//  QueueViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 25/4/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController {
    
    @IBOutlet weak var queueTable: UITableView!
	
	var controller: QueueController?
    
//    private var app = UIApplication.shared.delegate as! AppDelegate
    override var prefersStatusBarHidden: Bool { return true }
    
    public var backgroundColor: UIColor? {
        didSet {
            self.view.backgroundColor       = self.backgroundColor
            self.queueTable.backgroundColor = self.backgroundColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

		self.controller = QueueController(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /// Handler for the 'close' image
    ///
    /// - Parameter sender: The image itself
    @IBAction func goBack(_ sender: Any) {
        // Take out the current view from the stack and return to the previous one
        dismiss(animated: true, completion: nil)
    }
	
}

// MARK: UITableViewDataSource
extension QueueViewController: UITableViewDataSource {
    
    /// Datasource handler for tableview new cells creating
    ///
    /// - Parameters:
    ///   - tableView: TableView itself
    ///   - indexPath: Index of the new cell
    /// - Returns: The new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Request to the tableview for a new cell by its identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! QueueCell
        
        // Get the nth item from the song list
		guard let controller = self.controller,
			  let item = controller.getItem(byIndex: indexPath.row)
		else { return cell }
        
        // Render the new cell with the item information
        cell.render(item: item, color: self.backgroundColor)
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


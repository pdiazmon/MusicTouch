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
    
    private var app       = UIApplication.shared.delegate as! AppDelegate
    override var prefersStatusBarHidden: Bool { return true }
    
    public var backgroundColor: UIColor? {
        didSet {
            self.view.backgroundColor       = self.backgroundColor
            self.queueTable.backgroundColor = self.backgroundColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // Get the nth item from the data-store song list
        let item = app.dataStore.songList().items[indexPath.row]
        
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
        return app.dataStore.songList().count
    }

}


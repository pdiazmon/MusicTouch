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
    private let dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore
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
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension QueueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.dataStore.songList() {
            return list.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! QueueCell
        
        let item = self.dataStore.songList()!.items[indexPath.row]
        
        cell.render(item: item, color: self.backgroundColor)
        cell.selectionStyle = .none
        
        return cell
    }

}


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
    
    private var dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore
    private let app = UIApplication.shared.delegate as! AppDelegate
    
    override var prefersStatusBarHidden: Bool { return true }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Enable/disable play buttons depending on list emptyness
        if let stack = self.playButtonsStack {
            for button in stack.arrangedSubviews {
                if let button = (button as? UIButton) {
                    if let list = self.dataStore.songList() {
                        button.isEnabled = list.count > 0
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAllPressed(_ sender: UIButton) {
        startToPlay(shuffle: false)
    }
    
    @IBAction func shufflePressed(_ sender: Any) {
        startToPlay(shuffle: true)
    }
    
    private func startToPlay(shuffle: Bool,  index: Int = -1) {
        app.appPlayer.setCollection(self.dataStore.songList()!)
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        if (index >= 0) {
            app.appPlayer.setSong(self.dataStore.songList()?.items[index])
        }
        
        if let vc = tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
            vc.playSong()
        }
        
        tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
        tabBarController?.selectedIndex = TabBarItem.play.rawValue
    }
    
}

// MARK: UITableViewDataSource
extension SongViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.dataStore.songList() {
            return list.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SongCell
        
        let item = self.dataStore.songList()!.items[indexPath.row]
        
        cell.render(item: item)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SongViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startToPlay(shuffle: false, index: indexPath.row)
    }
}

extension SongViewController {
    public func reload() {
        self.songsTableView?.reloadData()
        
        // Enable/disable play buttons depending on list emptyness
        if let stack = self.playButtonsStack {
            for button in stack.arrangedSubviews {
                if let button = (button as? UIButton) {
                    if let list = self.dataStore.songList() {
                        button.isEnabled = list.count > 0
                    }
                }
            }
        }
    }

}


//
//  FirstViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class ArtistViewController: UIViewController {

    @IBOutlet weak var artistTable: UITableView!
    @IBOutlet weak var playButtonsStack: UIStackView!
    
    private var app       = UIApplication.shared.delegate as! AppDelegate
    private let dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.dataStore.refreshArtistList()
        
        // Enable/disable play buttons depending on list emptyness
        for button in self.playButtonsStack.arrangedSubviews {
            if let button = (button as? UIButton) {
                button.isEnabled = self.dataStore.artistList().count > 0
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
    
    @IBAction func shufflePressed(_ sender: UIButton) {
        startToPlay(shuffle: true)
    }
    
    private func startToPlay(shuffle: Bool) {
        
        self.dataStore.refreshSongList(byArtist: "", byAlbum: "")
        
        app.appPlayer.setCollection(self.dataStore.songList()!)
        
        if (shuffle) {
            app.appPlayer.shuffleModeOn()
        }
        else {
            app.appPlayer.shuffleModeOff()
        }
        
        if let vc = tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
            vc.playSong()
        }
        
        tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
        tabBarController?.selectedIndex = TabBarItem.play.rawValue
    }
}



extension ArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ArtistCell
        
        let item = self.dataStore.artistList()[indexPath.row]
        
        cell.render(item: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataStore.artistList().count
    }
    
}


// MARK: UITableViewDelegate
extension ArtistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let item = self.dataStore.artistList()[indexPath.row]
        
        dataStore.refreshAlbumList(byArtist: item.artist)
        
        let vc = tabBarController?.customizableViewControllers![TabBarItem.album.rawValue] as! AlbumViewController
        vc.reload()
        
        tabBarController?.selectedIndex = TabBarItem.album.rawValue
    }
    
    func swipeHandlerAux(indexPath: IndexPath, shuffle: Bool) {
        
        // Get the selected artist
        let item = self.dataStore.artistList()[indexPath.row]
        
        // Fill the songlist from the selected playlist in the datastore
        self.dataStore.refreshSongList(byArtist: item.artist)
        
        // Set the player collection from the datastore songlist
        self.app.appPlayer.setCollection(self.dataStore.songList()!)
        
        // Sets the shuffle mode
        if (shuffle) {
            self.app.appPlayer.shuffleModeOn()
        }
        else {
            self.app.appPlayer.shuffleModeOff()
        }
        
        // Wait and start playing the first song and, also, transition to the Play view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let vc = self.tabBarController?.customizableViewControllers![TabBarItem.play.rawValue] as? PlayViewController {
                vc.playSong()
            }
            
            self.tabBarController?.tabBar.items![TabBarItem.play.rawValue].isEnabled = true
            self.tabBarController?.selectedIndex                                     = TabBarItem.play.rawValue
        }
    }
    
    // Handler for swipe action over a cell
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let shuffleAction = UIContextualAction(style: .normal, title:  "Play", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            self.swipeHandlerAux(indexPath: indexPath, shuffle: true)
            
            success(true)
        })
        
        shuffleAction.image           = UIImage(named: "shuffle")
        shuffleAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [shuffleAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let playAction = UIContextualAction(style: .normal, title:  "Play", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            self.swipeHandlerAux(indexPath: indexPath, shuffle: false)
            
            success(true)
        })
        
        playAction.image           = UIImage(named: "playall")
        playAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [playAction])
    }
}



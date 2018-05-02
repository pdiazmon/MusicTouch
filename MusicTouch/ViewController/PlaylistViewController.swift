//
//  PlaylistViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    private let app       = UIApplication.shared.delegate as! AppDelegate
    private let dataStore = (UIApplication.shared.delegate as! AppDelegate).dataStore

    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataStore.refreshPlaylistList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PlaylistCell
        
        let item = self.dataStore.playlistList()[indexPath.row]
        
        cell.render(item: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataStore.playlistList().count
    }
    
}


// MARK: UITableViewDelegate
extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.dataStore.playlistList()[indexPath.row]
        
        dataStore.refreshSongList(byPlaylist: item.title)
        let vc = tabBarController?.customizableViewControllers![TabBarItem.song.rawValue] as! SongViewController
        vc.reload()
        
        tabBarController?.selectedIndex = TabBarItem.song.rawValue
    }
    
    func swipeHandlerAux(indexPath: IndexPath, shuffle: Bool) {

        // Get the selected playlist
        let item = self.dataStore.playlistList()[indexPath.row]
        
        // Fill the songlist from the selected playlist in the datastore
        self.dataStore.refreshSongList(byPlaylist: item.title)
        
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



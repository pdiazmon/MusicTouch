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
import UIFontComplete


class SongViewController: UIViewController {

    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var playButtonsStack: UIStackView!
    
    private let app = UIApplication.shared.delegate as! AppDelegate
    
    private var songList: [MTSongData] = []

    override var prefersStatusBarHidden: Bool { return true }
	
	private var songsRetriever: SongsRetrieverProtocol?

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
		
		var preparingPlay: Bool = false
		let preparingPlaySemaphore = DispatchSemaphore(value: 1)
		
		DispatchQueue.main.asyncAfter(deadline: .now()+0.005) {
			if (preparingPlay) {
				self.showSpinner(onView: self.songsTableView)
				preparingPlaySemaphore.wait()
				self.removeSpinner()
				preparingPlaySemaphore.signal()
			}
		}

		preparingPlaySemaphore.wait()
		preparingPlay = true

		// Use the songsRetriever object to read the songs from the Media Library.
		app.appPlayer.setCollection(self.songsRetriever!.songsCollection())
        
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
		
		preparingPlay = false
		preparingPlaySemaphore.signal()

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
		self.startToPlay(shuffle: false, index: indexPath.row)
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
	/// - Parameter mpMediaItemRetriever: Injected object to retrieve from Media Library the MPMediaItem list of songs
	func configure(songs: [MTSongData], songsRetriever: SongsRetrieverProtocol) {
        self.songList = songs
        self.reload()
		
		self.songsRetriever = songsRetriever
    }
    
    /// The ViewController has just appeared on screen. Load its data.
    ///
    /// - Parameter animated: If true, the view was added to the window using an animation.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (self.app.dataStore.isDataLoaded() && self.songList.count == 0) {
			self.configure(songs: self.app.dataStore.songList(), songsRetriever: self)
        }
        else if (!self.app.dataStore.isDataLoaded()) {

            // create an activity animation
            let activity = NVActivityIndicatorViewFactory.shared.getNewLoading(frame: self.songsTableView.frame)
            
            self.view.addSubview(activity)
            activity.startAnimating()
            
            // Asynchronously, in background, load the albums data
            DispatchQueue.main.async {
                
                if (self.songList.count == 0) {
					self.configure(songs: self.app.dataStore.songList(), songsRetriever: self)
                }
                
                // stop the animation
                activity.stopAnimating()
                activity.removeFromSuperview()
            }
        }
        
    }
    
}

extension SongViewController {
    func showSpinner(onView : UIView) {
		let size = CGSize(width: 30, height: 30)

		let activityData = ActivityData(size: size,
										message: "Loading ...",
										messageFont: UIFont(font: Font.helveticaLight, size: 15),
										type: .circleStrokeSpin)

		NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
			NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
	
	func isSpinnerAnimating() -> Bool {
		return NVActivityIndicatorPresenter.sharedInstance.isAnimating
	}
}

extension SongViewController: SongsRetrieverProtocol {
	func songsCollection() -> MPMediaItemCollection {
		// By default, retrieves the list of all existing songs in the Media Library
		return MPMediaItemCollection(items: PDMMediaLibrary.getSongsList())
	}
}

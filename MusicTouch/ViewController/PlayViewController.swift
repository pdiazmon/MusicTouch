//
//  PlayViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer

struct volumeGestureHandler {
    var initY: Float = 0.0
    var initValue: Float = 0.0
}

class PlayViewController: UIViewController {

    @IBOutlet weak var artworkImg: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var shuffleImg: UIImageView!
    
    private var app:                     AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private var volumeSlider:            UISlider?
    private var timerIsOn:               Bool = false
    private var timer:                   Timer?
    private var volumeGestureInProgress: Bool = false
    private var volumeView:              MPVolumeView!
    private var averageColorCache =      [Int: UIColor]()

    private var initVolumeScale = Float()
    private var initVolumeLevel = Float()
    private var volumeHandler   = volumeGestureHandler()
    private var volumeBoxView   = VolumeView(color: UIColor.red)
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSetup()
        viewStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Handler for segue transitions preparation
    ///
    /// - Parameters:
    ///   - segue: segue to perform identifier
    ///   - sender: Object performing the segue transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set the background color for the queue list as the artwork image average color
        if let queue = segue.destination as? QueueViewController {
            queue.backgroundColor = self.progress.progressTintColor
        }
    }
}

// MARK: View preparation
extension PlayViewController {
  
    /// Add and initialize objects to the view
    func viewSetup() {
        
        self.view.addSubview(volumeBoxView)
        
        // Set the progress bar to zero
        self.progress.progress = 0.0
        
        // Gets the system volume handler object 
        self.volumeSlider = MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider
        
        // Allows us to hide the system volume HUD giving it a zero frame
        self.volumeView = MPVolumeView(frame: .zero)
        view.addSubview(volumeView)
      
        // Add an observer: when the system volume changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(volumeChanged),
                                               name: NSNotification.Name.MPMusicPlayerControllerVolumeDidChange,
                                               object: nil)

        // Add an observer: when the playing song changes over the self.app.appPlayer object
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: self.app.appPlayer.getPlayer())
        self.app.appPlayer.getPlayer().beginGeneratingPlaybackNotifications()
    }
  
    /// Set the view objects style
    func viewStyle() {
        
        // Add a shadow to the artwork image
        self.artworkImg.layer.shadowColor   = UIColor.darkGray.cgColor
        self.artworkImg.layer.shadowOpacity = 1
        self.artworkImg.layer.shadowOffset  = CGSize.zero
        self.artworkImg.layer.shadowRadius  = 10
        
        // Add a blur view over the background image
        self.blurEffectView.effect           = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView.frame            = view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
        // Set the progress bar higher than default
        self.progress.transform =  self.progress.transform.scaledBy(x: 1, y: 3)
    }
}

// MARK: Actions
extension PlayViewController {
    
    /// Play the current song
    func playSong() {
        self.app.appPlayer.playSong()
        
        // If the timer is not running, start it
        if (!timerIsOn) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            timerIsOn = true
        }
    }
    
    /// Pause the current song
    func pauseSong() {
        self.app.appPlayer.pauseSong()
    }
  
    /// Animates the view objects when changes to the previous song
    ///
    /// - Parameter flipDuration: Animation duration
    func animatePreviousSong(_ flipDuration: Double) {
        DispatchQueue.main.async {
            UIView.transition(with: self.artworkImg, duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.artistLbl,  duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.albumLbl,   duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.songLbl,    duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }      
    }

    /// Animates the view objects when changes to the next song
    ///
    /// - Parameter flipDuration: Animation duration
    func animateNextSong(_ flipDuration: Double) {
        DispatchQueue.main.async {
            UIView.transition(with: self.artworkImg, duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.artistLbl,  duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.albumLbl,   duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.songLbl,    duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}

// MARK: Utils
extension PlayViewController {
    
    /// Gets the average color from the current song artwork
    ///
    /// - Parameter image: Artwork image
    /// - Returns: Average color
    func getAverageColor(image: UIImage) -> UIColor? {
        
        // Get the album unique id
        let id = AlbumID(artist: self.app.appPlayer.nowPlayingArtist(), album: self.app.appPlayer.nowPlayingAlbumTitle())
        
        // If the current album average color is stored in the cache, return it
        if let cacheValue = averageColorCache[id.hashValue] {
            return cacheValue
        }
        else { // if not, read it, store it in the cache and return it
            let averageColor                = image.averageColor
            averageColorCache[id.hashValue] = averageColor
            return averageColor
        }
    }
}

// Event handlers
extension PlayViewController {
    
    /// When the playing song changes, changes the view objects accordingly
    @objc func updateView() {
      
        DispatchQueue.main.async {
            
            // Song title
            self.songLbl.text = self.app.appPlayer.nowPlayingTitle()
            
            // If album title has not changed, we assume that either artist and artwork haven't changed
            if (self.albumLbl.text  != self.app.appPlayer.nowPlayingAlbumTitle()) {
             
                // Album title
                self.albumLbl.text  = self.app.appPlayer.nowPlayingAlbumTitle()
                
                // Artist name
                self.artistLbl.text = self.app.appPlayer.nowPlayingArtist()

                // Artwork image
                if let artwork = self.app.appPlayer.nowPlayingArtwork() {
                    self.artworkImg.image    = artwork.image(at: CGSize(width: 150, height: 150))
                    self.backgroundImg.image = self.artworkImg.image
                    
                    // Progress bar
                    if let image = self.artworkImg.image {
                        self.progress.progressTintColor = self.getAverageColor(image: image)
                    }
                }
            }
            
            // Show the shuffle icon if shuffle play mode is on
            self.shuffleImg.isHidden = !self.app.appPlayer.isShuffleOn()
        }
    }
        
    /// While timer run, update the progress objects accordingly
    @objc func updateProgress() {
        
        // If the music is not playing or the app is in background, we don't need to update them
        guard (self.app.appPlayer.isPlaying() && app.appStatus == .foreground) else { return }
        
        // Update the progress bar
        let currentPlaybackTime = app.appPlayer.nowPlayingPlaybackTime()
        DispatchQueue.main.async {
            self.progress.setProgress(Float(currentPlaybackTime / self.app.appPlayer.nowPlayingDuration()), animated: true)
        }
        
        // Update the progress time label
        var minutes = Int(currentPlaybackTime / 60)
        var seconds = Int(currentPlaybackTime.truncatingRemainder(dividingBy: 60))
        DispatchQueue.main.async {
            self.progressLbl.text = String(format: "%0i:%02i", minutes, seconds)
        }
        
        // Update the remaining time label
        DispatchQueue.main.async {
            minutes = Int((self.app.appPlayer.nowPlayingDuration() - currentPlaybackTime) / 60)
            seconds = Int((self.app.appPlayer.nowPlayingDuration() - currentPlaybackTime).truncatingRemainder(dividingBy: 60))
            
            self.durationLbl.text = String(format: "-%0i:%02i", minutes, seconds)
        }
    }
    
    /// Tap event handler for play/pause the music
    ///
    /// - Parameter recognizer: Gesture recognizer object
    @IBAction func tapPlayPause(_ recognizer: UIGestureRecognizer) {
        
        // If the tap has began (the finger is still touching the screen
        if (recognizer.state == .began) {
            
            // Reduces the artwork shadow opacity
            self.artworkImg.layer.shadowOpacity = 0.5

            // If the music was playing, pause it
            if (app.appPlayer.isPlaying()) {
                pauseSong()
            }
            // If the music was paused, play it
            else if (app.appPlayer.isPaused()) {
                playSong()
            }
        }
        // The tap has finished (the finger is not touching anymore the screen)
        else if ( recognizer.state == .ended) {
            // Set back the artwork shadow opacity to its previous value
            self.artworkImg.layer.shadowOpacity = 1
        }
    }
    
    /// Pan gesture event handler to increase/decrease volume
    ///
    /// - Parameter recognizer: Pan gesture recognizer
    @IBAction func handleVolume(_ recognizer: UIPanGestureRecognizer) {
        
        let location = recognizer.location(in: recognizer.view)
        
        switch recognizer.state {
        case .began: // The pan gesture has just started
            
            if let volumeSlider = self.volumeSlider {
                // Read the Y position of the fingers and the current volume value
                self.volumeHandler.initY     = Float(location.y)
                self.volumeHandler.initValue = volumeSlider.value
                initVolumeLevel              = Float(self.volumeHandler.initValue)
                
                // Show the transparent view with the volume
                volumeBoxView.changeVolume(to: CGFloat(initVolumeLevel))
                volumeBoxView.show()

                volumeGestureInProgress = true
            }
            
        case .changed: // The pan gesture continues moving
            
            if let volumeSlider = self.volumeSlider {
                // Calculate the delta Y movement from its last position and the new volume level accordingly
                let incrDeltaY     = (self.volumeHandler.initY - Float(location.y)) / Float((recognizer.view?.frame.height)!)
                let newVolumeLevel = self.volumeHandler.initValue + incrDeltaY
                
                // If the delta Y movement is less than 0.01 we do not change the volume
                if (abs(initVolumeLevel - newVolumeLevel) >= 0.01 && newVolumeLevel <= 1 && newVolumeLevel >= 0) {
                    // Increase/decrease the volume level
                    volumeSlider.setValue(newVolumeLevel, animated: false)
                    initVolumeLevel = newVolumeLevel

                    // Change the volume value in the transparent view
                    volumeBoxView.changeVolume(to: CGFloat(newVolumeLevel))
                }
            }
            
        case .ended: // The pan gesture has finished
            // Hides the volume view
            volumeBoxView.hide()
            
            volumeGestureInProgress = false
            
        default:
            break
        }
    }
    
    /// Volume level change handler
    ///
    /// - Parameter notification: Volume change notification
    @objc func volumeChanged(_ notification: Notification) {
        
        // If the user is changing the volume using a pan gesture, return as the change is being handle by the gesture handler
        guard (volumeGestureInProgress == false) else { return }
        
        if (notification.name == NSNotification.Name.MPMusicPlayerControllerVolumeDidChange) {
            if let volumeSlider = self.volumeSlider {
                
                // Show a the transparent view with the new volume label and hide it after a time
                volumeBoxView.changeVolume(to: CGFloat(volumeSlider.value))
                volumeBoxView.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.volumeBoxView.hide()
                }
            }
        }

    }

    /// Swipe gesture handler to go to the previuos/next song
    ///
    /// - Parameter gesture: Swipe gesture recognizer
    @IBAction func handleGesture(_ gesture: UISwipeGestureRecognizer) {
        let flipDuration = 0.4
        
        // If the swipe is from right to left, play the previous song
        if (gesture.direction == UISwipeGestureRecognizerDirection.right && !app.appPlayer.isPlayingFirst()) {
            app.appPlayer.playPrevious()
          
            animatePreviousSong(flipDuration)
        }
        // If the swipe is from left to right, play the next song
        else if (gesture.direction == UISwipeGestureRecognizerDirection.left && !app.appPlayer.isPlayingLast()) {
            app.appPlayer.playNext()
          
            animateNextSong(flipDuration)
        }        
    }
}

//
//  PlayViewController.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer
import VHUD
//import FXBlurView

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

    private var volumeBar       = VHUDContent(.percentComplete)
    private var initVolumeScale = Float()
    private var initVolumeLevel = Float()
    private var volumeHandler   = volumeGestureHandler()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Set the background color for the queue list as the artwork image average color
        if let queue = segue.destination as? QueueViewController {
            queue.backgroundColor = self.progress.progressTintColor
        }
    }
    
}

extension PlayViewController {
  
    func viewSetup() {
        // Set the progress bar to zero
        self.progress.progress = 0.0
        
        // Gets the system volume handler object 
        self.volumeSlider = MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider
        
        // Allows us to hide the system volume HUD giving it a zero frame
        self.volumeView = MPVolumeView(frame: .zero)
        //self.volumeView.showsRouteButton = false
        view.addSubview(volumeView)
      
        // Observe when the system volume changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(volumeChanged),
                                               name: NSNotification.Name.MPMusicPlayerControllerVolumeDidChange,
                                               object: nil)

        // Observe when the playing song changes over the self.app.appPlayer object
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: self.app.appPlayer.getPlayer())
        self.app.appPlayer.getPlayer().beginGeneratingPlaybackNotifications()
    }
  
    func viewStyle() {
        self.volumeBar.shape      = .circle
        self.volumeBar.style      = .blur(.light)
        self.volumeBar.background = .blur(.dark)
        
        // Add a shadow to the artwork image
        self.artworkImg.layer.shadowColor   = UIColor.darkGray.cgColor //UIColor.black.cgColor
        self.artworkImg.layer.shadowOpacity = 1
        self.artworkImg.layer.shadowOffset  = CGSize.zero
        self.artworkImg.layer.shadowRadius  = 10
        
        self.blurEffectView.effect           = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView.frame            = view.bounds  //view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
        // Set the progress bar higher
        self.progress.transform =  self.progress.transform.scaledBy(x: 1, y: 3)
    }
  
    func playSong() {
        self.app.appPlayer.playSong()
        
        if (!timerIsOn) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            timerIsOn = true
        }
    }
    
    func pauseSong() {
        self.app.appPlayer.pauseSong()
    }
  
    func animatePreviousSong(_ flipDuration: Double) {
        DispatchQueue.main.async {
            UIView.transition(with: self.artworkImg, duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.artistLbl, duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.albumLbl, duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.songLbl, duration: flipDuration, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }      
    }
  
    func animateNextSong(_ flipDuration: Double) {
        DispatchQueue.main.async {
            UIView.transition(with: self.artworkImg, duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.artistLbl, duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.albumLbl, duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        DispatchQueue.main.async {
            UIView.transition(with: self.songLbl, duration: flipDuration, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
    
    func getAverageColor(image: UIImage) -> UIColor? {
        let id = AlbumID(artist: self.app.appPlayer.nowPlayingArtist(), album: self.app.appPlayer.nowPlayingAlbumTitle())
        
        if let cacheValue = averageColorCache[id.hashValue] {
            print("Average color for \(self.app.appPlayer.nowPlayingAlbumTitle()!) present in cache")
            return cacheValue
        }
        else {
            let averageColor = image.averageColor
            averageColorCache[id.hashValue] = averageColor
            
            print("Average color for \(self.app.appPlayer.nowPlayingAlbumTitle()!) NOT present in cache")
            return averageColor
        }
    }
}

// @objc and @IBAction and selector functions
extension PlayViewController {
    
    @objc func updateView() {
      
        // Update the view accondingly with the current song
        DispatchQueue.main.async {
            self.songLbl.text = self.app.appPlayer.nowPlayingTitle()
            
            // If album title has not changed, we assume that either artist and artwork haven't changed
            if (self.albumLbl.text  != self.app.appPlayer.nowPlayingAlbumTitle()) {
                
                self.albumLbl.text  = self.app.appPlayer.nowPlayingAlbumTitle()
                self.artistLbl.text = self.app.appPlayer.nowPlayingArtist()

                if let artwork = self.app.appPlayer.nowPlayingArtwork() {
                    self.artworkImg.image    = artwork.image(at: CGSize(width: 150, height: 150))
                    self.backgroundImg.image = self.artworkImg.image
                    
                    if let image = self.artworkImg.image {
                        self.progress.progressTintColor = self.getAverageColor(image: image)
                    }
                }
            }
            
            // Show the shuffle icon if shuffle play mode is on
            self.shuffleImg.isHidden = !self.app.appPlayer.isShuffleOn()
        }
    }
        
    @objc func updateProgress() {
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
    
    @IBAction func tapPlayPause(_ recognizer: UIGestureRecognizer) {
        
        if (recognizer.state == .began) {
            self.artworkImg.layer.shadowOpacity = 0.5

            if (app.appPlayer.isPlaying()) {
                pauseSong()
                
//                self.playImg.image = UIImage(named: "icons-pause")
            }
            else if (app.appPlayer.isPaused()) {
                playSong()
                
//                self.playImg.image = UIImage(named: "icons-play")
            }
            
//            DispatchQueue.main.async {
//                self.playImg.isHidden = false
//                UIView.animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
//                    self.playImg.alpha = 0
//                }, completion: { finished in
//                    self.playImg.isHidden = true
//                    self.playImg.alpha = 0.5
//                })
//            }

        }
        else if ( recognizer.state == .ended) {
            self.artworkImg.layer.shadowOpacity = 1
        }
        
    }
    
    @IBAction func handleVolume(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: recognizer.view)
        
        switch recognizer.state {
        case .began:
            if let volumeSlider = self.volumeSlider {
                self.volumeHandler.initY     = Float(location.y)
                self.volumeHandler.initValue = volumeSlider.value
                initVolumeLevel = Float(self.volumeHandler.initValue)
                VHUD.show(volumeBar)
                volumeGestureInProgress = true
            }
        case .changed:
            
            if let volumeSlider = self.volumeSlider {
                let incrDeltaY = (self.volumeHandler.initY - Float(location.y)) / Float((recognizer.view?.frame.height)!)
                let newVolumeLevel = self.volumeHandler.initValue + incrDeltaY
                
                if (abs(initVolumeLevel - newVolumeLevel) >= 0.01) {
                    volumeSlider.setValue(newVolumeLevel, animated: false)
                    initVolumeLevel = newVolumeLevel
                    VHUD.updateProgress(CGFloat(volumeSlider.value))
                }
            }
            
        case .ended:
            VHUD.dismiss(0.5, 0.5)
            volumeGestureInProgress = false
        default:
            break
        }
    }
    
    @objc func volumeChanged(_ notification: Notification) {
        
        guard (volumeGestureInProgress == false) else { return }
        

        if (notification.name == NSNotification.Name.MPMusicPlayerControllerVolumeDidChange) {
            if let volumeSlider = self.volumeSlider {
                VHUD.show(volumeBar)
                VHUD.updateProgress(CGFloat(volumeSlider.value))
                VHUD.dismiss(1, 1)
            }
        }

    }

    @IBAction func handleGesture(_ gesture: UISwipeGestureRecognizer) {
        let flipDuration = 0.4
        
        if (gesture.direction == UISwipeGestureRecognizerDirection.right && !app.appPlayer.isPlayingFirst()) {
            app.appPlayer.playPrevious()
          
            animatePreviousSong(flipDuration)
        }
        else if (gesture.direction == UISwipeGestureRecognizerDirection.left && !app.appPlayer.isPlayingLast()) {
            app.appPlayer.playNext()
          
            animateNextSong(flipDuration)
        }        
    }
    

}

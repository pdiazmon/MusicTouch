//
//  PDMPlayer.swift
//  PDMUtils
//
//  Created by Pedro L. Diaz Montilla on 11/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import MediaPlayer

enum PlayStatus {
    case playing
    case pause
}

public class PDMPlayer: PlayerProtocol {
    private var player:          MPMusicPlayerController
    private var playStatus:      PlayStatus
    private var songsCollection: MPMediaItemCollection = MPMediaItemCollection(items: [])
    private var shuffle:         Bool = false
    
    public init() {
        
        // MPMusicPlayerController provides different music players. System Music Player is used, and the rest are commented
        self.player     = MPMusicPlayerController.systemMusicPlayer
        //self.player     = MPMusicPlayerController.applicationMusicPlayer
        //self.player     = MPMusicPlayerController.applicationQueuePlayer
        self.playStatus = .pause
    }
    
    /// Returns the player constoller instance
    /// - Returns: The MPMusicPlayerController instance used
    public func getPlayer() -> MPMusicPlayerController {
        return player
    }
    
    /// Switch on the shuffle mode over the songs list
    public func shuffleModeOn() {
        self.player.shuffleMode = MPMusicShuffleMode.songs
        self.shuffle = true
    }
    
    /// Switch off the shuffle mode
    public func shuffleModeOff() {
        self.player.shuffleMode = MPMusicShuffleMode.off
        self.shuffle = false
    }
    
    /// Starts playing the songs collection
    public func playSong() {
        self.playStatus = .playing
        self.player.play()
    }
    
    /// Pauses the playing
    public func pauseSong() {
        self.playStatus = .pause
        self.player.pause()
    }
    
    /// Sets the songs queue
    /// - Parameters:
    ///   - collection: A MPMediaItemCollection containing all the songs to be played
    public func setCollection(_ collection: MPMediaItemCollection) {
        self.songsCollection = collection
        self.player.setQueue(with: self.songsCollection)
    }
    
    /// Return the current player queue collection
    ///
    /// - Returns: Current player queue collection
    public func getCollection() -> MPMediaItemCollection {
        return self.songsCollection
    }
    
    /// Sets the current song to be played to a given one
    /// - Parameters:
    ///   - song: The song to be played now
    public func setSong(_ song: MPMediaItem?) {
        guard (song != nil) else { return }
        self.player.nowPlayingItem = song!
    }
    
    /// Returns the album cover for the currently played song
    /// - Returns: The cover image artwork
    public func nowPlayingArtwork() -> MPMediaItemArtwork? {
        guard (songsCollection.count > 0)    else { return nil }
        guard (player.nowPlayingItem != nil) else { return nil }
        
        return player.nowPlayingItem?.artwork
    }
    
    /// Returns the song title for the currently played song
    /// - Returns: The song title
    public func nowPlayingTitle() -> String? {
        guard (songsCollection.count > 0)    else { return nil }
        guard (player.nowPlayingItem != nil) else { return nil }

        return player.nowPlayingItem?.title
    }

    /// Returns the album title for the currently played song
    /// - Returns: The album title
    public func nowPlayingAlbumTitle() -> String? {
        guard (songsCollection.count > 0)    else { return nil }
        guard (player.nowPlayingItem != nil) else { return nil }
        
        return player.nowPlayingItem?.albumTitle
    }

    /// Returns the album artist name for the currently played song
    /// - Returns: The album artist name
    public func nowPlayingArtist() -> String? {
        guard (songsCollection.count > 0)    else { return nil }
        guard (player.nowPlayingItem != nil) else { return nil }
        
        return player.nowPlayingItem?.albumArtist
    }
    
    /// Returns the currently played song current play time
    /// - Returns: The play time
    public func nowPlayingPlaybackTime() -> TimeInterval {
        return player.currentPlaybackTime
    }

    /// Returns the currently played song duration
    /// - Returns: Song duration
    public func nowPlayingDuration() -> TimeInterval {
        return (player.nowPlayingItem?.playbackDuration)!
    }

    /// Starts playing the next song in the queue
    public func playNext() {
        player.skipToNextItem()
    }

    /// Starts playing the previous song in the queue
    public func playPrevious() {
        player.skipToPreviousItem()
    }
    
    /// Tells if the currently played song is the first one in the queue
    /// - Returns: true if the current played song is the first. false if not.
    public func isPlayingFirst() -> Bool {
        return player.nowPlayingItem == self.songsCollection.items.first
    }

    /// Tells if the currently played song is the last one in the queue
    /// - Returns: true if the current played song is the last. false if not.
    public func isPlayingLast() -> Bool {
        return player.nowPlayingItem == self.songsCollection.items.last
    }
    
    /// Tells if the player is currently playing a song
    /// - Returns: true if any song is being played now. false if not.
    public func isPlaying() -> Bool {
        return self.playStatus == .playing
    }

    /// Tells if the player is currently paused
    /// - Returns: true if the player is paused. false if not.
    public func isPaused() -> Bool {
        return self.playStatus == .pause
    }
    
    /// Tells if the shuffle mode is active
    /// - Returns: true if the shuffle mode is on. false if not.
    public func isShuffleOn() -> Bool {
        return self.shuffle
    }

}

//
//  MTPlaylistCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class MTPlaylistCell: MTCellDelegate {
    
    private let numberOfSongs = UILabel()
    private let playTime      = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
        layoutView()
        style()
    }
    
    func setup() {
        self.addSubview(numberOfSongs)
        self.addSubview(playTime)
    }
    
    func layoutView() {
        
        // Number of Albums
        self.numberOfSongs.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfSongs.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.numberOfSongs.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        self.numberOfSongs.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.numberOfSongs.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
        
        // Play time
        self.playTime.translatesAutoresizingMaskIntoConstraints = false
        self.playTime.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.playTime.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        self.playTime.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.playTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
    }
    
    func style() {
        // Number of Albums
        self.numberOfSongs.textAlignment = .left
        self.numberOfSongs.font          = UIFont(font: appFontItalic, size: 14)
		self.numberOfSongs.textColor     = UIColor.label
        
        // Play time
        self.playTime.textAlignment = .right
        self.playTime.font          = UIFont(font: appFontItalic, size: 12)
		self.playTime.textColor     = UIColor.label
    }
    
    func render(item: MTData) {
        
        if let itemPlaylist = item as? MTPlaylistData {
            
            self.numberOfSongs.text = "\(itemPlaylist.numberOfSongs) song" + ((itemPlaylist.numberOfSongs > 1) ? "s" : "")
            
            self.playTime.text = (itemPlaylist.playTime.hours > 0) ? "\(itemPlaylist.playTime.hours):" : ""
            self.playTime.text = self.playTime.text! + String(format: "%02i:%02i", itemPlaylist.playTime.minutes, itemPlaylist.playTime.seconds)
            
        }
    }
    
}


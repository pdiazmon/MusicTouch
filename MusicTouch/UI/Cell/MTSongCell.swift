//
//  MTSongCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer

class MTSongCell: MTCellDelegate {
    
    private let artistName = UILabel()
    private let albumTitle = UILabel()
    private let playTime   = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
        layoutView()
        style()
    }
    
	/// Sets up the cell elements
    func setup() {
        self.addSubview(artistName)
        self.addSubview(albumTitle)
        self.addSubview(playTime)
    }
    
	/// Organizes the cell elements
    func layoutView() {
        
        // Artist Name
        self.artistName.translatesAutoresizingMaskIntoConstraints = false
        self.artistName.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.artistName.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.artistName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        self.artistName.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        // Number of Songs
        self.albumTitle.translatesAutoresizingMaskIntoConstraints = false
        self.albumTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.albumTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.albumTitle.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        self.albumTitle.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
        
        // Play time
        self.playTime.translatesAutoresizingMaskIntoConstraints = false
        self.playTime.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.playTime.centerYAnchor.constraint(equalTo: albumTitle.centerYAnchor).isActive = true
        self.playTime.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.playTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
    }
    
	/// Applies the style to the cell elements
    func style() {
        // Artist Name
        self.artistName.textAlignment = .left
        self.artistName.font          = UIFont(font: appFontItalic, size: 13)
		self.artistName.textColor     = UIColor.label
        
        // Number of Albums
        self.albumTitle.textAlignment = .left
        self.albumTitle.font          = UIFont(font: appFontItalic, size: 13)
		self.albumTitle.textColor     = UIColor.label
        
        // Play time
        self.playTime.textAlignment = .right
        self.playTime.font          = UIFont(font: appFontItalic, size: 12)
		self.playTime.textColor     = UIColor.label
    }
    
	/// Render the cell elements with the appropiate date
	/// - Parameter item: data item
    func render(item: MTData) {
        
        if let itemSong = item as? MTSongData {
			self.artistName.text = "\(itemSong.albumArtist())"
            self.albumTitle.text = "\(itemSong.albumTitle())"
            
            self.playTime.text = (itemSong.playTime.hours > 0) ? "\(itemSong.playTime.hours):" : ""
            self.playTime.text = self.playTime.text! + String(format: "%02i:%02i", itemSong.playTime.minutes, itemSong.playTime.seconds)
            
        }
    }
    
}

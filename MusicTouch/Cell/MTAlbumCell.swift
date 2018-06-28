//
//  MTAlbumCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit


class MTAlbumCell: MTCellDelegate {
    
    private let artistName    = UILabel()
    private let numberOfSongs = UILabel()
    private let playTime      = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
        layoutView()
        style()
    }
    
    func setup() {
        self.addSubview(artistName)
        self.addSubview(numberOfSongs)
        self.addSubview(playTime)
    }
    
    func layoutView() {

        // Artist Name
        self.artistName.translatesAutoresizingMaskIntoConstraints = false
        self.artistName.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.artistName.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.artistName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        self.artistName.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        // Number of Songs
        self.numberOfSongs.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfSongs.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.numberOfSongs.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.numberOfSongs.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        self.numberOfSongs.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
        
        // Play time
        self.playTime.translatesAutoresizingMaskIntoConstraints = false
        self.playTime.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.playTime.centerYAnchor.constraint(equalTo: numberOfSongs.centerYAnchor).isActive = true
        self.playTime.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.playTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
    }
    
    func style() {
        // Artist Name
        self.artistName.textAlignment = .left
        self.artistName.font = UIFont(font: appFontItalic, size: 13)
        
        // Number of Albums
        self.numberOfSongs.textAlignment = .left
        self.numberOfSongs.font          = UIFont(font: appFontItalic, size: 13)
        
        // Play time
        self.playTime.textAlignment = .right
        self.playTime.font          = UIFont(font: appFontItalic, size: 12)
    }
    
    func render(item: MTData) {
        
        if let itemAlbum = item as? MTAlbumData {
            self.artistName.text = "\(itemAlbum.artistName)" + ((itemAlbum.year != nil) ? "  [\(String(itemAlbum.year!))]" : "")
            
            self.numberOfSongs.text = "\(itemAlbum.numberOfSongs) song" + ((itemAlbum.numberOfSongs > 1) ? "s" : "")
            
            self.playTime.text = (itemAlbum.playTime.hours > 0) ? "\(itemAlbum.playTime.hours):" : ""
            self.playTime.text = self.playTime.text! + String(format: "%02i:%02i", itemAlbum.playTime.minutes, itemAlbum.playTime.seconds)
            
        }
    }
    
}

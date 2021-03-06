//
//  MTArtistCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class MTArtistCell: MTCellDelegate {
    
    private let numberOfAlbums = UILabel()
    private let playTime       = UILabel()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        setup()
        layoutView()
        style()
    }
    
	/// Sets up the cell elements
    func setup() {
        self.addSubview(numberOfAlbums)
        self.addSubview(playTime)
    }
    
	/// Organizes the cell elements
    func layoutView() {
        
        // Number of Albums
        self.numberOfAlbums.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfAlbums.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.numberOfAlbums.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        self.numberOfAlbums.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.numberOfAlbums.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
        
        // Play time
        self.playTime.translatesAutoresizingMaskIntoConstraints = false
        self.playTime.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.playTime.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        self.playTime.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.playTime.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45).isActive = true
    }
  
	/// Applies the style to the cell elements
    func style() {
        // Number of Albums
        self.numberOfAlbums.textAlignment = .left
        self.numberOfAlbums.font          = UIFont(font: appFontItalic, size: 14)
		self.numberOfAlbums.textColor     = UIColor.label

        // Play time
        self.playTime.textAlignment = .right
        self.playTime.font          = UIFont(font: appFontItalic, size: 12)
		self.playTime.textColor     = UIColor.label
    }
    
	/// Render the cell elements with the appropiate date
	/// - Parameter item: data item
    func render(item: MTData) {
        
        if let itemArtist = item as? MTArtistData {
            
            self.numberOfAlbums.text = "\(itemArtist.numberOfAlbums) album" + ((itemArtist.numberOfAlbums > 1) ? "s" : "")
            
            self.playTime.text = (itemArtist.playTime.hours > 0) ? "\(itemArtist.playTime.hours):" : ""
            self.playTime.text = self.playTime.text! + String(format: "%02i:%02i", itemArtist.playTime.minutes, itemArtist.playTime.seconds)
    
        }
    }
    
}

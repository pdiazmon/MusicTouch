//
//  MTCellLondon.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 28/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit


class MTCellLondon: MTCell {
    
    private let sideBar = UIView()
    private let title   = UILabel()
    
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
        layoutView()
        style()
    }
    
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        self.addSubview(sideBar)
        self.addSubview(title)
        self.addSubview(img)
        
        super.setup()
    }
    
    override func layoutView() {
        // Side Bar
        self.sideBar.translatesAutoresizingMaskIntoConstraints = false
        self.sideBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9).isActive = true
        self.sideBar.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.sideBar.widthAnchor.constraint(equalToConstant: 7).isActive = true
        self.sideBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        
        // Image
        self.img.translatesAutoresizingMaskIntoConstraints = false
        self.img.leftAnchor.constraint(equalTo: self.sideBar.leftAnchor, constant: 15).isActive = true
        self.img.centerYAnchor.constraint(equalTo: self.sideBar.centerYAnchor).isActive = true
        self.img.heightAnchor.constraint(equalTo: self.sideBar.heightAnchor, multiplier: 0.8).isActive = true
        self.img.widthAnchor.constraint(equalTo: self.sideBar.heightAnchor, multiplier: 0.8).isActive = true
        
        // Title
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.leftAnchor.constraint(equalTo: img.rightAnchor, constant: 10).isActive = true
        self.title.topAnchor.constraint(equalTo: img.topAnchor).isActive = true
        self.title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.title.heightAnchor.constraint(equalTo: img.heightAnchor, multiplier: 0.45).isActive = true
        
        // Delegate View
        if let del = delegate {
            del.translatesAutoresizingMaskIntoConstraints = false
            del.bottomAnchor.constraint(equalTo: img.bottomAnchor, constant: -10).isActive = true
            del.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
            del.rightAnchor.constraint(equalTo: title.rightAnchor).isActive = true
            del.heightAnchor.constraint(equalTo: img.heightAnchor, multiplier: 0.45).isActive = true
        }
        
        super.layoutView()
    }
    
    override func style() {
        // Title
        self.title.textAlignment = .left
        self.title.font          = self.title.font.withSize(18)
		self.title.textColor     = UIColor.label
        
        super.style()
    }
    
    override func render(item: MTData) {
        self.title.text  = item.title()
        
        if item.image() != nil {
            self.img.image = item.image
            self.clipsToBounds = true
        }
        
        if let del = delegate {
            if (del is MTPlaylistCell) { self.sideBar.backgroundColor = MTCellFactory.shared.londonColor(TabBarItem.playlist) }
            else if (del is MTArtistCell) { self.sideBar.backgroundColor = MTCellFactory.shared.londonColor(TabBarItem.artist) }
            else if (del is MTAlbumCell) { self.sideBar.backgroundColor = MTCellFactory.shared.londonColor(TabBarItem.album) }
            else if (del is MTSongCell) { self.sideBar.backgroundColor = MTCellFactory.shared.londonColor(TabBarItem.song) }
        }
        
        super.render(item: item)
    }
    
}

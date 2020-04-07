//
//  MTCellParis.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 26/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import Foundation
import UIKit
import UIFontComplete

class MTCellParis: MTCell {
    
    private let backgroundGrey = UIView()
    private let backgroundBox  = UIView()
    private let title          = UILabel()
    private let img            = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        setup()
        layoutView()
        style()

        super.layoutSubviews()
    }
    
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        self.addSubview(backgroundGrey)
        self.addSubview(backgroundBox)
        self.addSubview(title)
        self.addSubview(img)

        super.setup()        
    }
    
    override func layoutView() {
        // Background Grey
        self.backgroundGrey.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundGrey.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.backgroundGrey.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.backgroundGrey.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.backgroundGrey.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Background Box
        self.backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundBox.centerXAnchor.constraint(equalTo: self.backgroundGrey.centerXAnchor).isActive = true
        self.backgroundBox.centerYAnchor.constraint(equalTo: self.backgroundGrey.centerYAnchor).isActive = true
        self.backgroundBox.widthAnchor.constraint(equalTo: self.backgroundGrey.widthAnchor, multiplier: 0.98).isActive = true
        self.backgroundBox.heightAnchor.constraint(equalTo: self.backgroundGrey.heightAnchor, multiplier: 0.98).isActive = true
        
        // Image
        self.img.translatesAutoresizingMaskIntoConstraints = false
        self.img.leftAnchor.constraint(equalTo: backgroundBox.leftAnchor, constant: 10).isActive = true
        self.img.centerYAnchor.constraint(equalTo: backgroundBox.centerYAnchor).isActive = true
        self.img.heightAnchor.constraint(equalTo: backgroundBox.heightAnchor, multiplier: 0.8).isActive = true
        self.img.widthAnchor.constraint(equalTo: backgroundBox.heightAnchor, multiplier: 0.8).isActive = true
        
        // Title
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.leftAnchor.constraint(equalTo: img.rightAnchor, constant: 10).isActive = true
        self.title.topAnchor.constraint(equalTo: backgroundBox.topAnchor).isActive = true
        self.title.rightAnchor.constraint(equalTo: backgroundBox.rightAnchor, constant: -10).isActive = true
        self.title.heightAnchor.constraint(equalTo: backgroundBox.heightAnchor, multiplier: 0.45).isActive = true
        
        // Delegate View
        if let del = delegate {
            del.translatesAutoresizingMaskIntoConstraints = false
            del.bottomAnchor.constraint(equalTo: backgroundBox.bottomAnchor, constant: -10).isActive = true
            del.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
            del.heightAnchor.constraint(equalTo: backgroundBox.heightAnchor, multiplier: 0.45).isActive = true
            del.widthAnchor.constraint(equalTo: title.widthAnchor).isActive = true
        }

        super.layoutView()
    }
    
    override func style() {
        // Background Grey
//        self.backgroundGrey.backgroundColor = UIColor.lightGray
		self.backgroundGrey.backgroundColor = UIColor.systemBackground
        
        // Background Box
//        self.backgroundBox.backgroundColor    = UIColor.white
		self.backgroundBox.backgroundColor    = UIColor.secondarySystemBackground
        self.backgroundBox.layer.cornerRadius = self.frame.height * 0.1
        
        // Title
        self.title.textAlignment = .left
        self.title.font          = UIFont(font: appFont, size: 18)  //self.title.font.withSize(18)
		self.title.textColor     = UIColor.label
        
        // Image
        self.img.layer.cornerRadius = self.img.frame.height * 0.1

        super.style()
    }
    
    override func render(item: MTData) {
        self.title.text  = item.title()
        
        if item.image() != nil {
            self.img.setAndRound(item.image()!, ratio: 0.1)
        }

        super.render(item: item)
    }
    
}

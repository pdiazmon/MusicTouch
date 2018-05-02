//
//  AlbumCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var albumImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: render
extension AlbumCell {
    /// Extracts the values from the item and puts them into the label
    ///
    /// - Parameter item: Item
    func render(item: Album) {
        self.albumLbl.text   = item.album
        
        if (item.image != nil) {
            self.albumImg.image = item.image
            self.albumImg.layer.cornerRadius = self.albumImg.frame.height/2
            self.albumImg.clipsToBounds = true
            
        }
    }
}

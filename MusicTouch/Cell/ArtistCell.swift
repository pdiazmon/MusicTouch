//
//  ArtistCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {

    @IBOutlet weak var artistLbl: UILabel!

    @IBOutlet weak var artistImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ArtistCell {
    func render(item: Artist) {
        self.artistLbl.text  = item.artist
        
        if item.image != nil {
            self.artistImg.setAndRound(item.image!)
        }
    }

}


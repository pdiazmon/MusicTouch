//
//  PlaylistCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 23/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {

    @IBOutlet weak var playlistLbl: UILabel!
    @IBOutlet weak var playlistImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PlaylistCell {
    func render(item: Playlist) {
        self.playlistLbl.text  = item.title
        
        if item.image != nil {
            self.playlistImg.setAndRound(item.image!)
        }
    }
    
}


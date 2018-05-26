//
//  SongCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 19/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer

class SongCell: UITableViewCell {

    @IBOutlet weak var songLbl: UILabel!
    @IBOutlet weak var songImg: UIImageView!
    
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
extension SongCell {
    /// Extracts the values from the item and puts them into the label and image
    ///
    /// - Parameter item: Media item
    func render(item: MPMediaItem) {
        self.songLbl.text  = item.title
        
        if let image = item.artwork?.image(at: CGSize(width: 75.0, height: 75.0)) {
            self.songImg.setAndRound(image)
        }
        
    }
}

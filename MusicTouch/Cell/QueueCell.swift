//
//  QueueCellTableViewCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 25/4/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer

class QueueCell: UITableViewCell {

    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var songLbl: UILabel!
    
    private let app       = UIApplication.shared.delegate as! AppDelegate
    
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
extension QueueCell {
    /// Extracts the values from the item and puts them into the label
    ///
    /// - Parameter item: Item
    func render(item: MPMediaItem, color: UIColor?) {
        self.songLbl.text  = item.title
        
        // If it is the current playing song ..
        if (item == app.appPlayer.getPlayer().nowPlayingItem) {
            self.songImg.image = UIImage(named: "speaker", in: Bundle(for: type(of: self)), compatibleWith: nil)
        }
        else {
            self.songImg.image = item.artwork?.image(at: CGSize(width: 50.0, height: 50.0))            
            self.songImg.layer.cornerRadius = self.songImg.frame.height/2
            self.songImg.clipsToBounds = true
        }
        
        self.backgroundColor = color
    }
}

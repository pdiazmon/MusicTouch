//
//  QueueCellTableViewCell.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 25/4/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit
import MediaPlayer
import NVActivityIndicatorView

class QueueCell: UITableViewCell {

    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var songLbl: UILabel!
    
    private let app       = UIApplication.shared.delegate as! AppDelegate
    private var activity: NVActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        activity?.removeFromSuperview()
        songLbl.text = ""
        songImg.image = nil
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
            activity = NVActivityIndicatorViewFactory.shared.getNewPlaying(frame: CGRect.zero)
            self.addSubview(activity!)
            activity?.frame = self.songImg.frame.scale(by: 0.5)
            activity?.startAnimating()            
        }
        else {
            if let image = item.artwork?.image(at: CGSize(width: 50.0, height: 50.0)) {
                self.songImg.setAndRound(image)
            }
        }
        
        self.backgroundColor = color
    }
}

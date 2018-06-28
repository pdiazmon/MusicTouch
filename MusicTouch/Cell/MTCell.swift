//
//  MTCell.swif
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 20/6/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

class MTCell: UITableViewCell {
    
    var delegate: MTCellDelegate?
    
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.delegate = nil
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.delegate = nil
        
        super.init(coder: aDecoder)
    }
    
    func setup() {
        if let del = delegate {
            self.addSubview(del)
            del.setup()
        }
    }
    
    func layoutView() {
        if let del = delegate {
            del.layoutView()
        }
    }
    
    func style() {
        if let del = delegate {
            del.style()
        }
    }
    
    func render(item: MTData) {
        if let del = delegate {
            del.render(item: item)
        }
    }
    
}

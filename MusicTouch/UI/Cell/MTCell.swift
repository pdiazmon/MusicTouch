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
	
    let img = UIImageView()
    
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
        self.delegate = nil
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.delegate = nil
        
        super.init(coder: aDecoder)
    }
	
	/// Sets up the cell elements
    func setup() {
        if let del = delegate {
            self.addSubview(del)
            del.setup()
        }
    }
	
	/// Organizes the view elements
    func layoutView() {
        if let del = delegate {
            del.layoutView()
        }
    }
	
	/// Applies the style to the cell elements
    func style() {
        if let del = delegate {
            del.style()
        }
    }
	
	/// Render the cell elements with the appropiate data
	/// - Parameter item: data item
    func render(item: MTData) {
        if let del = delegate {
            del.render(item: item)
        }
    }
    
}

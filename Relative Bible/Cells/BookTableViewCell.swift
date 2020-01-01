//
//  BookTableViewCell.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    static let identifier = "Book Table View Cell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

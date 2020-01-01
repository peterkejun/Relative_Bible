//
//  BibleTextCell.swift
//  Bible
//
//  Created by Jun Ke on 8/6/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class BibleTextCell: UITableViewCell {
    
    static let identifier = "Bible Text Cell"
    
    static var textColor: UIColor = .black
    
    @IBOutlet weak var verseLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

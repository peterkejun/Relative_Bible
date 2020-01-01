//
//  VerseRefCellCollectionViewCell.swift
//  Bible
//
//  Created by Jun Ke on 9/24/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class VerseRefCell: UICollectionViewCell {
    
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var verseLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    static let identifier = "Verse Ref Cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

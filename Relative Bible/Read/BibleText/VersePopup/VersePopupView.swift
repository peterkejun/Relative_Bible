//
//  VersePopupView.swift
//  Bible
//
//  Created by Jun Ke on 8/11/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol VersePopupViewDelegate: class {
    func dismissPopupView(_ popupView: VersePopupView)
    var alertControllerPresentable: UIViewController { get }
    func setHighlightColor(_ color: UIColor?)
    func setVerseLiked(_ flag: Bool)
}

class VersePopupView: UIView {
    
    var verse: Verse = Verse.init(book: "Genesis", chapter: 1, verseNumber: 1, content: "In the beginning God created the heaven and the earth.")
    
    var verseLabel: UILabel!
    var contentLabel: UILabel!
    var actionScrollView: UIScrollView!
    var highlightScrollView: UIScrollView!
    var copyButton: UIButton!
    var likeButton: UIButton!
    var shareButton: UIButton!
    var cancelButton: UIButton!
    
    var postcardImageView: UIImageView!
    
    weak var delegate: VersePopupViewDelegate?
    
    init(frame: CGRect, verse: Verse) {
        super.init(frame: frame)
        self.verse = verse
        self.layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var highlightColorsHex: [String] {
        return [
            "007AFF", "01B84D", "FF9500", "FF2D54", "AF52DE", "5856D6", "FFFFFF"
        ]
    }
    
}

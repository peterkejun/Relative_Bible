//
//  CharacterConcordanceLayout.swift
//  Bible
//
//  Created by Jun Ke on 9/22/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol CharacterConcordanceLayoutDelegate: class {
    func concordanceCollectionView(_ collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath) -> CGFloat
    func concordanceCollectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CharacterConcordanceLayout: UICollectionViewLayout {
    
    weak var delegate: CharacterConcordanceLayoutDelegate?
    
    fileprivate let numberOfRows = 2
    fileprivate let cellPadding: CGFloat = 6
    
    fileprivate var cache: [UICollectionViewLayoutAttributes] = []
    
    fileprivate var contentWidth: CGFloat = 0
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - insets.top - insets.bottom
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize.init(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }
        self.cache.removeAll()
        
        let rowHeight = contentHeight / CGFloat(numberOfRows)
        var yOffset: [CGFloat] = []
        for row in 0..<numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        var row = 0
        var xOffsets = [CGFloat].init(repeating: 0, count: numberOfRows)
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath.init(item: item, section: 0)
            
            let cellWidth = delegate.concordanceCollectionView(collectionView, widthForCellAtIndexPath: indexPath)
            let width = cellWidth + cellPadding * 2
            let frame = CGRect.init(x: xOffsets[row], y: yOffset[row], width: width, height: rowHeight)
            let insetsFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            attributes.frame = insetsFrame
            cache.append(attributes)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffsets[row] += width
            
            row = row < numberOfRows - 1 ? (row + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}


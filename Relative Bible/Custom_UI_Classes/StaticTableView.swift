//
//  StaticTableView.swift
//  Bible
//
//  Created by Jun Ke on 8/1/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol StaticTableViewDelegate: class {
    func staticTableView(_ staticTableView: StaticTableView, populateView view: UIView, ofIndex index: Int)
}

class StaticTableView: UIView {
    
    weak var delegate: StaticTableViewDelegate?
    
    static let standardRowHeight: CGFloat = 44
    
    private(set) var count: Int = 0
    private(set) var views: [UIView] = []
    private(set) var rowHeight: CGFloat = StaticTableView.standardRowHeight
    
    init(frame: CGRect, count: Int, rowHeight: CGFloat = StaticTableView.standardRowHeight, delegate: StaticTableViewDelegate) {
        super.init(frame: frame)
        self.count = count
        self.delegate = delegate
        self.rowHeight = rowHeight
        self.delegate = delegate
        reload()
    }
    
    func reload() {
        for view in views {
            view.removeFromSuperview()
        }
        views.removeAll()
        for n in 0..<count {
            let view = UIView.init()
            view.backgroundColor = UIColor.white
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat(n) * rowHeight).isActive = true
            view.heightAnchor.constraint(equalToConstant: rowHeight).isActive = true
            if n != count - 1 {
                let seperator = UIView.init()
                seperator.backgroundColor = UIColor.init(hex: "E9E9EC")
                view.addSubview(seperator)
                seperator.translatesAutoresizingMaskIntoConstraints = false
                seperator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
                seperator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                seperator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            }
            views.append(view)
        }
        for (n, view) in views.enumerated() {
            delegate?.staticTableView(self, populateView: view, ofIndex: n)
        }
        self.layoutIfNeeded()
        self.frame = CGRect.init(x: frame.minX, y: frame.minY, width: frame.width, height: views[count - 1].frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

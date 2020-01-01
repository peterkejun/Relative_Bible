//
//  HomeViewController.swift
//  Bible
//
//  Created by Jun Ke on 8/23/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var topicsScrollableView: ParallaxScrollableView!
    
    var votdView: UIView!
    var votdViewHeightConstraint: NSLayoutConstraint!
    var votd_spinner: UIActivityIndicatorView?
    var verseTagLabel: UILabel!
    var verseLabel: UILabel!
    var thoughtsLabel: UILabel!
    var prayerButton: UIButton!
    var prayerLabel: UILabel!
    var collapsePrayer: Bool = false
    
    var tdView: UIView!
    var tdViewHeightConstraint: NSLayoutConstraint!
    var td_spinner: UIActivityIndicatorView?
    var tdTitleLabel: UILabel!
    var tdAuthorLabel: UILabel!
    var tdContentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Relative Bible"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "info"), style: .plain, target: self, action: #selector(self.infoBarButtonPressed(sender:)))

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        self.layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.topicsScrollableView.autoScroll = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.topicsScrollableView.autoScroll = false
    }
    
    var topicsScrollableViewHeight: CGFloat {
        return 215
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

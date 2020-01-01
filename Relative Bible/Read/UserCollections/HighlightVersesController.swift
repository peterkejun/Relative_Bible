//
//  HighlightVersesController.swift
//  Bible
//
//  Created by Jun Ke on 8/25/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

fileprivate typealias Highlight = (VerseTag, String, Date)

protocol HighlightVersesControllerDelegate: class {
    func highlightVersesController(_ viewController: HighlightVersesController, didSelectVerse verseTag: VerseTag)
}

class HighlightVersesController: UITableViewController {
    
    weak var delegate: HighlightVersesControllerDelegate?
    
    var highlights = UserData.highlights.sorted { (first, second) -> Bool in
        return first.2.compare(second.2) == .orderedDescending
    }
    
    var segmentedControl: UISegmentedControl!
    
    var attributes: [NSAttributedString.Key : Any] = [:]
    
    var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        self.tableView.register(UINib.init(nibName: "BibleTextCell", bundle: nil), forCellReuseIdentifier: BibleTextCell.identifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.firstLineHeadIndent = 34
        paragraphStyle.lineSpacing = 12
        self.attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        
        self.segmentedControl = UISegmentedControl.init(items: ["by Date", "by Color", "by Book"])
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: UIControl.Event.valueChanged)
        self.navigationItem.titleView = self.segmentedControl
        
        self.dateFormatter = DateFormatter.init()
        self.dateFormatter.dateFormat = "H:mm MMM d, yyyy"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return highlights.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BibleTextCell.identifier, for: indexPath) as! BibleTextCell
        let (verseTag, colorHex, _) = self.highlights[indexPath.section]
        if let text = BibleData.bibleText(book: verseTag.book, chapter: verseTag.chapter, verseNumber: verseTag.verseNum, version: ReadViewController.version) {
            let attributedText = NSMutableAttributedString.init(string: text, attributes: self.attributes)
            attributedText.addAttribute(.backgroundColor, value: UIColor.init(hex: colorHex), range: .init(location: 0, length: attributedText.length))
            print(colorHex)
            cell.verseLabel.attributedText = attributedText
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let verseTag = self.highlights[section].0
        return verseTag.description
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.detailTextLabel?.text = self.dateFormatter.string(from: self.highlights[section].2)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let verseTag = self.highlights[indexPath.section].0
        self.delegate?.highlightVersesController(self, didSelectVerse: verseTag)
    }
    
    @objc func segmentedControlValueChanged() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.highlights.sort { (first, second) -> Bool in
                return first.2.compare(second.2) == .orderedDescending
            }
            self.tableView.reloadData()
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            self.highlights.sort { (first, second) -> Bool in
                let index1 = VersePopupView.highlightColorsHex.firstIndex(of: first.1)! as Int
                let index2 = VersePopupView.highlightColorsHex.firstIndex(of: second.1)! as Int
                return index1.compare(index2) == .orderedAscending
            }
            self.tableView.reloadData()
        } else {
            self.highlights.sort { (first, second) -> Bool in
                return first.0.compare(second.0) == ComparisonResult.orderedAscending
            }
            self.tableView.reloadData()
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LikedVersesController.swift
//  Bible
//
//  Created by Jun Ke on 8/21/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit

protocol LikedVersesControllerDelegate: class {
    func likedVersesController(_ viewController: LikedVersesController, didSelectVerse verseTag: VerseTag)
}

class LikedVersesController: UITableViewController {
    
    weak var delegate: LikedVersesControllerDelegate?
    
    var verseTags: [VerseTag] = []
    
    var attributes: [NSAttributedString.Key : Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            self.view.backgroundColor = UIColor.systemGray6
        } else {
            self.view.backgroundColor = UIColor.white
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "Liked"
        
        self.tableView.register(UINib.init(nibName: "BibleTextCell", bundle: nil), forCellReuseIdentifier: BibleTextCell.identifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.verseTags = UserData.likedVerseTags
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.firstLineHeadIndent = 34
        paragraphStyle.lineSpacing = 12
        self.attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.verseTags.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BibleTextCell.identifier, for: indexPath) as! BibleTextCell
        // Configure the cell...
        let verseTag = self.verseTags[indexPath.section]
        let text = BibleData.bibleText(book: verseTag.book, chapter: verseTag.chapter, verseNumber: verseTag.verseNum, version: ReadViewController.version) ?? "Not found"
        let attributedText = NSAttributedString.init(string: text, attributes: self.attributes)
        cell.verseLabel.attributedText = attributedText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let verseTag = self.verseTags[section]
        return verseTag.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Dislike") { (action, indexPath) in
            let verseTag = self.verseTags[indexPath.section]
            UserData.removeLiked(book: verseTag.book, chapter: verseTag.chapter, verse: verseTag.verseNum)
            self.verseTags = UserData.likedVerseTags
            self.tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .automatic)
        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.likedVersesController(self, didSelectVerse: self.verseTags[indexPath.section])
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

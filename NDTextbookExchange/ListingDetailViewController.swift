//
//  ListingDetailViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/9/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse
import Nuke

class ListingDetailViewController: UIViewController {
    
    var bookTitle: String = ""
    var bookID: String = ""
    var url: URL!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = bookTitle
        Nuke.loadImage(with: url, into: bookImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Listing", message: "Are you sure you want to delete your book listing?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Delete", style: .default, handler: {(alert: UIAlertAction!) in self.deleteListing()})
        let noAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        self.present(alert, animated: true, completion: nil)

    }
    
        func deleteListing() {
        
            let query = PFQuery(className: "Book")
            query.whereKey("objectId",  equalTo: self.bookID)
            query.findObjectsInBackground { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackground()
                        NSLog("Successfully deleted book.")
                    }
                }
                else {
                    NSLog("Error: \(error)")
                }
            }
            _ = navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

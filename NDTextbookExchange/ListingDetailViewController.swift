//
//  ListingDetailViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/9/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse

class ListingDetailViewController: UIViewController {
    
    var bookTitle: String = ""
    var bookID: String = ""

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = bookTitle
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

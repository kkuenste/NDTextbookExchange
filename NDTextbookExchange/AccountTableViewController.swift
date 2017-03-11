//
//  AccountTableViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse

class AccountTableViewController: UITableViewController {

    var books = [PFObject]()
    var email = PFUser.current()?.email
    
    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "Book")
        query.whereKey("seller",  equalTo: email!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.books = objects!
                self.tableView.reloadData()
            }
            else {
                NSLog("Error: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let listingCell = cell as? AccountListingTableViewCell  {
            listingCell.titleLabel.text = books[indexPath.row]["title"] as! String?
            listingCell.isbnLabel.text = books[indexPath.row]["ISBN"] as! String?
            
            DispatchQueue.main.async(execute: {
                if let imageURL = self.books[indexPath.row]["image"] {
                    if let url = NSURL(string: imageURL as! String) {
                        if let data = NSData(contentsOf: url as URL) {
                            listingCell.bookImage.image = UIImage(data: data as Data)
                        }
                    }
                }
            })
        }
        
        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ListingDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            dest.bookTitle = (self.books[indexPath.row]["title"] as! String?)!
            dest.bookID = self.books[indexPath.row].objectId!
        }
    }


}

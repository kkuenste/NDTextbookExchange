//
//  AccountTableViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse
import Nuke

class AccountTableViewController: UITableViewController {

    var books = [PFObject]()
    var email = PFUser.current()?.email
    
    @IBAction func logoutButton(_ sender: Any) {
        let attributedString = NSAttributedString(string: "Are you sure you want to log out?", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName : UIColor.black])
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        let yesAction = UIAlertAction(title: "Log out", style: .default, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
        let noAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "Book")
        query.whereKey("seller",  equalTo: email!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.books = objects!
                self.books.reverse()
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
            listingCell.priceLabel.text = "$\(books[indexPath.row]["price"]!)"
            listingCell.authorLabel.text = books[indexPath.row]["author"] as! String?
            
            let url = NSURL(string: (self.books[indexPath.row]["image"] as! String)) as! URL
            Nuke.loadImage(with: url, into: listingCell.bookImage)
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ListingDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            dest.bookTitle = (self.books[indexPath.row]["title"] as! String?)!
            dest.bookID = self.books[indexPath.row].objectId!
            dest.url = NSURL(string: (self.books[indexPath.row]["image"] as! String)) as! URL
            dest.price = self.books[indexPath.row]["price"] as! String
            dest.author = self.books[indexPath.row]["author"] as! String
            dest.descText = self.books[indexPath.row]["description"] as! String
            dest.isbn = self.books[indexPath.row]["ISBN"] as! String
        }
    }


}

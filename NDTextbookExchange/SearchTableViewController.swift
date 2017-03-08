//
//  SearchTableViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse

class SearchTableViewController: UITableViewController {
    
    var user = User()
    var books = [PFObject]()

    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "Book")
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
        
        if let bookCell = cell as? BookTableViewCell  {
            bookCell.titleLabel.text = books[indexPath.row]["title"] as! String?
            bookCell.isbnLabel.text = books[indexPath.row]["ISBN"] as! String?
            
            DispatchQueue.main.async(execute: {
                if let imageURL = self.books[indexPath.row]["image"] {
                    if let url = NSURL(string: imageURL as! String) {
                        if let data = NSData(contentsOf: url as URL) {
                            bookCell.bookImage.image = UIImage(data: data as Data)
                        }
                    }
                }
            })

        }

        return cell
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

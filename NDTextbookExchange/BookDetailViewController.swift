//
//  BookDetailViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/8/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Nuke
import Parse

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var bookTitle = ""
    var url: URL!
    var author = ""
    var isbn = ""
    var seller = ""
    var price = ""
    var descText = ""
    var sellerName = ""
    
    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = bookTitle
        Nuke.loadImage(with: url, into: bookImage)
        authorLabel.text = author
        isbnLabel.text = "ISBN: \(isbn)"
        sellerLabel.text = "Seller: \(seller)"
        //priceLabel.text = "Price: \(price)"
        descLabel.text = descText
        
        
        /*
        let query = PFQuery(className: "User")
        query.whereKey("seller",  equalTo: email!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.sellerName = objects!
            }
            else {
                NSLog("Error: \(error)")
            }
        }
        */


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

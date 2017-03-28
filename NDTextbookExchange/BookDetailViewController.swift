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
    @IBOutlet weak var descTextView: UITextView!
    
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
        priceLabel.text = "Price: \(price)"
        descTextView.text = descText

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        descTextView.flashScrollIndicators()
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

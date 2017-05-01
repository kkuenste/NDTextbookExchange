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
import MessageUI

class BookDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
    var objectId = ""
    var phone = ""
    
    var userName = ""
    
    @IBOutlet weak var contactSellerButton: UIButton!
    @IBOutlet weak var contactSellerEmailButton: UIButton!
    
    @IBAction func logoutButton(_ sender: Any) {
        let attributedString = NSAttributedString(string: "Are you sure you want to log out?", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 17),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = bookTitle
        Nuke.loadImage(with: url, into: bookImage)
        authorLabel.text = author
        isbnLabel.text = "ISBN: \(isbn)"
        sellerLabel.text = "Seller: \(seller)"
        priceLabel.text = "Price: $\(price)"
        descTextView.text = descText
        
        if seller == PFUser.current()?.email {
            contactSellerButton.isEnabled = false
            contactSellerButton.setTitleColor(UIColor.gray, for: .disabled)
            contactSellerEmailButton.isEnabled = false
            contactSellerEmailButton.setTitleColor(UIColor.gray, for: .disabled)
        }
        
        let query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: seller)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                NSLog("count: \(objects?.count)")
                for object in objects! {
                    self.phone = object["phone"] as! String
                }
            }
            else {
                NSLog("Error: \(error)")
            }
        }
        
        userName = PFUser.current()?["name"] as! String

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        descTextView.flashScrollIndicators()
    }
    
    @IBAction func contactSellerButton(_ sender: Any) {
        
        var text = "Hi, my name is \(userName). I saw your listing for \"\(bookTitle)\" on the ND Textbook Exchange app. Are you still selling?"
        
        text = text.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        
        NSLog("button pressed")
        
        NSLog("sms:\(phone)&body=\(text)")
        guard let messageURL = NSURL(string: "sms:\(phone)&body=\(text)")
            else {
                NSLog("error 1")
                return
        }
        if UIApplication.shared.canOpenURL(messageURL as URL) {
            UIApplication.shared.open(messageURL as URL, options: [:], completionHandler: nil)
        } else {
            NSLog("error 2")
        }
    }
    
    @IBAction func contactSellerEmailButton(_ sender: Any) {
        
        let emailTitle = "\"\(bookTitle)\" Textbook"
        let messageBody = "Hello, my name is \(userName). I saw your listing for \"\(bookTitle)\" on the ND Textbook Exchange app. Are you still selling?"
        let toRecipents = [seller]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        mc.navigationBar.tintColor = UIColor.white
        mc.navigationBar.barTintColor = UIColor.white
        mc.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 17),
            NSForegroundColorAttributeName : UIColor.white]
        
        self.present(mc, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error:Error?) {
        
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription)")
        }
 
        controller.dismiss(animated: true, completion: nil)
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

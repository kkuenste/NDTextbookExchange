//
//  NewListingViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/7/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse
import SwiftyJSON
import Nuke

class NewListingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    var ISBN = ""
    var bookTitle = ""
    var authors = [String]()
    var authorsStr = ""
    var imageStr = ""
    var desc = ""
    var email = PFUser.current()?.email
    
    @IBAction func cancelButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func createListingButton(_ sender: Any) {
        
        if priceTextField.text != "" {
            let newBook = PFObject(className: "Book")
            newBook["ISBN"] = ISBN
            newBook["title"] = self.bookTitle
            newBook["author"] = self.authorsStr
            newBook["description"] = self.desc
            newBook["image"] = self.imageStr
            newBook["seller"] = PFUser.current()?.email
            newBook["price"] = self.priceTextField.text
        
            newBook.saveInBackground(block: {(_ succeeded: Bool, _ error: Error?) -> Void in
                if error != nil {
                    print("Error saving \(error)")
                }
                else {
                    print("Successfully added a book.")
                }
            })
            _ = navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Enter Price", message: "You must enter a price value for your textbook.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewListingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
                
        let url =  NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=ISBN:\(ISBN)&key=AIzaSyBL2LHPZ724Rs1RezJJKHzim0RzU5XnRo8")
        let request = NSMutableURLRequest(url: url! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest){
            (data, responseText, error) -> Void in
            if error != nil {
                print("Error: \(error)")
            } else {
                let result = String(data: data!, encoding: String.Encoding.ascii)!
                DispatchQueue.main.async(execute: {
                    self.resultJSON = result
                    self.parseJSONResponse(data: data! as NSData)
                })
            }
        }
        task.resume()
        
    }
    
    var resultJSON : String = "" {
        didSet {
            //print("setting output as \(resultJSON)")
        }
    }
    
    func parseJSONResponse( data : NSData ) -> Void {
        let json = JSON(data: data as Data)
        self.bookTitle = String(describing: json["items"][0]["volumeInfo"]["title"])
        let jsonAuthors = json["items"][0]["volumeInfo"]["authors"]
        self.imageStr = String(describing: json["items"][0]["volumeInfo"]["imageLinks"]["thumbnail"])
        self.desc = String(describing: json["items"][0]["volumeInfo"]["description"])
        
        for author in jsonAuthors {
            self.authors.append(String(describing: author.1))
            self.authorsStr.append("\(String(describing: author.1)), ")
        }
        
        if (authorsStr.characters.count > 2) {
            self.authorsStr.remove(at: self.authorsStr.index(before: self.authorsStr.endIndex))
            self.authorsStr.remove(at: self.authorsStr.index(before: self.authorsStr.endIndex))
        }
        
        titleLabel.text = self.bookTitle
        authorLabel.text = self.authorsStr
        descTextView.text = self.desc
        descTextView.flashScrollIndicators()
        
        let url = NSURL(string: "\(self.imageStr)&key=AIzaSyBL2LHPZ724Rs1RezJJKHzim0RzU5XnRo8") as! URL
        Nuke.loadImage(with: url, into: self.bookImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func dismissKeyboard() {
        view.endEditing(true)
    }
}

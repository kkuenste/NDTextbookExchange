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

class NewListingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    var ISBN = ""
    var bookTitle = ""
    var authors = [String]()
    var imageStr = ""
    var desc = ""
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createListingButton(_ sender: Any) {
        let newBook = PFObject(className: "Book")
        newBook["ISBN"] = ISBN
        newBook.saveInBackground(block: {(_ succeeded: Bool, _ error: Error?) -> Void in
            if error != nil {
                print("Error saving \(error)")
            }
            else {
                print("Successfully added a book.")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url =  NSURL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(ISBN)&key=AIzaSyBL2LHPZ724Rs1RezJJKHzim0RzU5XnRo8")
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
            // print("setting output as \(resultJSON)")
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
        }
        
        titleLabel.text = self.bookTitle
        
        DispatchQueue.main.async(execute: {
            let url = NSURL(string: "\(self.imageStr)&key=AIzaSyBL2LHPZ724Rs1RezJJKHzim0RzU5XnRo8")
            let data = NSData(contentsOf: url! as URL)
            self.bookImage.image = UIImage(data: data as! Data)
        })
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

}

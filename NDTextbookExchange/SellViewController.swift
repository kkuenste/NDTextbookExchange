//
//  SellViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse
import SwiftyJSON

class SellViewController: UIViewController {
    
    var ISBN: String = ""

    @IBOutlet weak var isbnTextField: UITextField!
    
    @IBAction func isbnButton(_ sender: Any) {
        if isbnTextField.text != "" {
            ISBN = isbnTextField.text!
            self.performSegue(withIdentifier: "isbnSegue", sender: self)
            isbnTextField.text = ""
        } else {
            let alert = UIAlertController(title: "Empty Field", message: "Please enter a book's ISBN.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func scanButton(_ sender: Any) {

    }

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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NewListingViewController {
            dest.ISBN = self.ISBN
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}

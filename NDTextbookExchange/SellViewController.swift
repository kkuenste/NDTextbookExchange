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
        ISBN = isbnTextField.text!
        self.performSegue(withIdentifier: "isbnSegue", sender: self)
        isbnTextField.text = ""
    }
    
    @IBAction func scanButton(_ sender: Any) {

    }

    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

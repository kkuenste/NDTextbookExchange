//
//  LoginViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.layer.cornerRadius = 5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        /*
        // Parse Testing Connection
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackground { (success, error) -> Void in
            print("Object has been saved.")
        }
        */
        
        
        //emailTextField.text = "kkuenste@nd.edu"
        //passwordTextField.text = "123"

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let userEmail = emailTextField.text!
        let userPassword = passwordTextField.text!
        
        if (!userEmail.isEmpty && !userPassword.isEmpty) {
            PFUser.logInWithUsername(inBackground: userEmail, password: userPassword) { (user, error) -> Void in
                if error == nil {
                    NSLog("succesful login")
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.user = User(email: userEmail, password: "", name: "", venmo: "")
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    NSLog("error: \(error!)")
                    let alert = UIAlertController(title: "Error Logging In", message: "Invalid Username and/or Password", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Empty Field", message: "You must fill in both the email and password text fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
        
    
    }
    
    // shifts the view up when the keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                //self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y -= 75
            }
        }
        
    }
    
    // shifts the view down when the keyboard disappears
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                //self.view.frame.origin.y += keyboardSize.height
                self.view.frame.origin.y += 75
            }
        }
    }
    
    // moves the text field from email to password
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField { // Switch focus to other text field
            passwordTextField.becomeFirstResponder()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchTableViewController {
            dest.user = self.user
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}

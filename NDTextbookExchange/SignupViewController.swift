//
//  SignupViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var activeField: UITextField?
    
    @IBOutlet weak var venmoTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var verifyTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func doneButton(_ sender: Any) {
        if (emailTextField.text == "" || passwordTextField.text == "" || verifyTextField.text == "" || nameTextField.text == "" || phoneTextField.text == "") {
            let alert = UIAlertController(title: "Empty Field", message: "You must fill in all required text fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
        else if (emailTextField.text?.range(of: "@nd.edu") == nil) {
            let alert = UIAlertController(title: "Notre Dame Email", message: "To create an account, you must use a Notre Dame email address.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
        else if (passwordTextField.text != verifyTextField.text) {
            let alert = UIAlertController(title: "Check Password", message: "Your password must match in both text fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
        else if !(validate(value: phoneTextField.text!)) {
            let alert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid phone number.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            // let user = User(email: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!, venmo: venmoTextField.text!)
            
            let userParse = PFUser()
            userParse.username = emailTextField.text!
            userParse.password = passwordTextField.text!
            userParse.email = emailTextField.text!
            userParse["venmoUsername"] = venmoTextField.text!
            userParse["name"] = nameTextField.text!
            userParse["phone"] = phoneTextField.text!

            // Signing up using the Parse API
            userParse.signUpInBackground {
                (success, error) -> Void in
                if let error = error as NSError? {
                    let errorString = error.userInfo["error"] as? NSString
                    NSLog(errorString as! String)
                } else {
                    NSLog("success signing up user")
                }
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.isTranslucent = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        verifyTextField.delegate = self
        nameTextField.delegate = self
        phoneTextField.delegate = self
        venmoTextField.delegate = self
        
    }
    
    // moves the text field from email to password
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField { // Switch focus to other text field
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            verifyTextField.becomeFirstResponder()
        } else if textField == verifyTextField {
            nameTextField.becomeFirstResponder()
        } else if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            venmoTextField.becomeFirstResponder()
        }
        
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if activeField != venmoTextField {
            activeField = nil
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // function to validate the user's phone number
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

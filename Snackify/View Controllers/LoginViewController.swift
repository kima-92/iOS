//
//  LoginViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var networkManager: NetworkManager?
    var authType = AuthType.logIn
    
    
    //MARK: Outlets
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var organizationTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    //MARK: Actions
    
    @IBAction func loginSegmentedControlChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            authType = .signUp
            //            loginButton.setTitle("Sign Up", for: .normal)
            updateViews()
        } else {
            authType = .logIn
            //            loginButton.setTitle("Log In", for: .normal)
            updateViews()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        // Creating a user
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            let fullname = fullNameTextField.text,
            let email = emailTextField.text,
            let phoneNum = phoneNumberTextField.text,
            let address = addressTextField.text,
            let state = stateTextField.text,
            let zipcode = zipcodeTextField.text,
            let organization = organizationTextField.text,
            username != "",
            password != "",
            fullname != "",
            email != "",
            phoneNum != "",
            address != "",
            state != "",
            zipcode != "",
            organization != "" else { return }
        
        //TODO : WR -> Create a user with out id IF id will be provited by back-end
        
//        let user = 
        // perform login or sign up operation based on loginType
        
        if authType == .signUp {
            signUp(with: user)
        } else {
            login(username: username, password: password)
        }
    }
    
    func signUp(with user: User) {
                
        networkManager?.signUp(with: user, completion: { (error) in
           
            let alert = UIAlertController(title: "Sign Up Successful!",
                                          message: "Please log in",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true) {
                    self.authType = .logIn
                    self.loginSegmentedControl.selectedSegmentIndex = 1
                    self.loginButton.setTitle("Log In", for: .normal)
                }
            }
        })
    }
    
    func login(username: String, password: String) {
        
        
        networkManager?.logIn(with: username, password: password) { result in
            
            do {
                let _ = try result.get()
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                NSLog("Error login in user")
            }
        }
    }
    
    func updateViews() {
        
        loginButton.layer.cornerRadius = 8.0
        
        if authType == .logIn {
            loginSegmentedControl.selectedSegmentIndex = 1
            
            fullNameTextField.alpha = 0
            emailTextField.alpha = 0
            phoneNumberTextField.alpha = 0
            addressTextField.alpha = 0
            stateTextField.alpha = 0
            zipcodeTextField.alpha = 0
            organizationTextField.alpha = 0
            
            fullNameTextField.isEnabled = false
            emailTextField.isEnabled = false
            phoneNumberTextField.isEnabled = false
            addressTextField.isEnabled = false
            stateTextField.isEnabled = false
            zipcodeTextField.isEnabled = false
            organizationTextField.isEnabled = false
            
            loginButton.setTitle("Log In", for: .normal)
            
            // TODO: WR  try to programmatically Constrain the logIn button under the password textfield
            
            //            loginButton.translatesAutoresizingMaskIntoConstraints = false
            //            NSLayoutConstraint(item: loginButton,
            //                               attribute: .top,
            //                               relatedBy: .bottomAnchor,
            //                               toItem: passwordTextField,
            //                               attribute: <#T##NSLayoutConstraint.Attribute#>,
            //                               multiplier: <#T##CGFloat#>,
            //                               constant: <#T##CGFloat#>)
            
        } else {
            
            loginSegmentedControl.selectedSegmentIndex = 0
            
            
            fullNameTextField.alpha = 1
            emailTextField.alpha = 1
            phoneNumberTextField.alpha = 1
            addressTextField.alpha = 1
            stateTextField.alpha = 1
            zipcodeTextField.alpha = 1
            organizationTextField.alpha = 1
            
            fullNameTextField.isEnabled = true
            emailTextField.isEnabled = true
            phoneNumberTextField.isEnabled = true
            addressTextField.isEnabled = true
            stateTextField.isEnabled = true
            zipcodeTextField.isEnabled = true
            organizationTextField.isEnabled = true
            
            loginButton.setTitle("Sign Up", for: .normal)
        }
    }
}

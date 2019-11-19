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
        
    }
    
    //MARK: Actions
    
    @IBAction func loginSegmentedControlChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            authType = .signUp
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            authType = .logIn
            loginButton.setTitle("Log In", for: .normal)
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
        
        //        let user = User(id: <#T##Int#>, firstName: <#T##String#>, lastName: <#T##String#>, username: <#T##String#>, email: <#T##String#>, phoneNumber: <#T##String#>, streetAddress: <#T##String#>, state: <#T##String#>, zipCode: <#T##String#>, organization: <#T##Organization#>, isAdmin: <#T##Bool#>)
        
        // perform login or sign up operation based on loginType
        
        if authType == .signUp {
            //            signUp(with: user)
        } else {
            //            signIn(with: user)
        }
    }
    
    func signUp(with user: User) {
        
        //TODO: Implement sign Up in the NetworkManager

//        networkManager?.signUp(with: user, completion: { (error) in
//
//            if let error = error {
//                NSLog("Error occurred during sign up: \(error)")
//            } else {
//                let alert = UIAlertController(title: "Sign Up Successful",
//                                              message: "Please log in",
//                                              preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                alert.addAction(okAction)
//
//                DispatchQueue.main.async {
//                    self.present(alert, animated: true) {
//                        self.authType = .signIn
//                        self.loginSegmentedControl.selectedSegmentIndex = 1
//                        self.loginButton.setTitle("Log In", for: .normal)
//                    }
//                }
//            }
//        })
    }
    
    func login(with user: User) {
        
        //TODO: Implement login in the NetworkManager
        
//        networkManager?.signIn(with: user, completion: { (error) in
//            if let error = error {
//                NSLog("Error occurred during sign in: \(error)")
//            } else {
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//        })
    }
    
    func updateViews() {
        
        loginButton.layer.cornerRadius = 8.0
    }
    
    
    
}

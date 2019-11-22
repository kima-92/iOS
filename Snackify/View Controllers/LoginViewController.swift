//
//  LoginViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var networkManager: NetworkManager?
    var authType = AuthType.logIn
    var userType = UserType.employee
    var delegate: SnacksMainViewController?
    
    // MARK: - Outlets
    
    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
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
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginSegmentedControl.selectedSegmentIndex = 1
//        navigationItem.hidesBackButton = true
        updateViews()
    }
    
    func updateViews() {
        loginButton.layer.cornerRadius = 8.0
        passwordTextField.isSecureTextEntry = true
        
        let authTypeIsLogin = (authType == .logIn)
        
        loginSegmentedControl.selectedSegmentIndex = authTypeIsLogin ? 1 : 0
        roleSegmentedControl.selectedSegmentIndex = (userType == UserType.organization) ? 1 : 0
        
        fullNameTextField.isHidden = authTypeIsLogin
        emailTextField.isHidden = authTypeIsLogin
        phoneNumberTextField.isHidden = authTypeIsLogin
        addressTextField.isHidden = authTypeIsLogin
        stateTextField.isHidden = authTypeIsLogin
        zipcodeTextField.isHidden = authTypeIsLogin
        organizationTextField.isHidden = authTypeIsLogin || userType.isAdmin
        
        fullNameTextField.isEnabled = !authTypeIsLogin
        emailTextField.isEnabled = !authTypeIsLogin
        phoneNumberTextField.isEnabled = !authTypeIsLogin
        addressTextField.isEnabled = !authTypeIsLogin
        stateTextField.isEnabled = !authTypeIsLogin
        zipcodeTextField.isEnabled = !authTypeIsLogin
        organizationTextField.isEnabled = !(authTypeIsLogin || userType.isAdmin)
        
        loginButton.setTitle((authTypeIsLogin ? "Log In" : "Sign Up"), for: .normal)
        
        fullNameTextField.placeholder = (userType == .organization) ? "Organization Name" : "Full Name"
    }
    
    //MARK: Actions
    
    @IBAction func roleSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userType = .employee
            updateViews()
        } else {
            userType = .organization
            updateViews()
        }
    }
    
    @IBAction func loginSegmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            authType = .signUp
            updateViews()
        } else {
            authType = .logIn
            updateViews()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        // Creating a user
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            username != "",
            password != ""
            else { return }
        
        // perform login or sign up operation based on loginType
        if authType == .signUp {
            guard let fullname = fullNameTextField.text,
                let email = emailTextField.text,
                let phoneNum = phoneNumberTextField.text,
                let address = addressTextField.text,
                let state = stateTextField.text,
                let zipcode = zipcodeTextField.text,
                fullname != "",
                email != "",
                phoneNum != "",
                address != "",
                state != "",
                zipcode != ""
                else { return }
            if !(userType == .organization) {
                guard let organization = organizationTextField.text,
                    organization != ""
                    else { return }
            }
            let user = User(username: username, password: password, fullName: fullname, email: email, phoneNumber: phoneNum, streetAddress: address, state: state, zipCode: zipcode, isAdmin: false, isOrganization: userType == .organization)
            signUp(with: user)
        } else {
            logIn(username: username, password: password)
        }
    }
    
    // MARK: - Login/Sign-up methods
    
    func signUp(with user: User) {
        networkManager?.signUp(with: user, completion: { (result) in
            do {
                let _ = try result.get()
            } catch {
                if let error = error as? NetworkError {
                    NSLog("Error signing up: \(error.rawValue)")
                    DispatchQueue.main.async {
                        self.showNetworkFailAlert(withAuthType: .signUp, error: error)
                    }
                } else {
                    NSLog("Error signing up: \(error)")
                    self.showNetworkFailAlert(withAuthType: .signUp, error: .otherError)
                }
                return
            }
            let alert = UIAlertController(title: "Sign Up Successful!",
                                          message: "Please log in",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true) {
                    self.authType = .logIn
                    self.updateViews()
                }
            }
        })
    }
    
    func logIn(username: String, password: String) {
        networkManager?.logIn(with: username,
                              password: password,
                              isOrganization: userType == .organization
        ) { result in
            do {
                let bearer = try result.get()
                print("Success! Bearer: \(bearer.token)")
                
                DispatchQueue.main.async {
                    self.delegate?.snackManager = SnackManager(networkManager: self.networkManager!)
                    self.delegate?.updateViews()
                    self.dismiss(animated: true, completion: nil)
                }
            } catch {
                NSLog("Error loginng in: \(error)")
                let caughtError = error as? NetworkError ?? NetworkError.otherError
                DispatchQueue.main.async {
                    self.showNetworkFailAlert(withAuthType: .logIn, error: caughtError)
                }
            }
        }
    }
    
    func showNetworkFailAlert(withAuthType authType: AuthType, error: NetworkError) {
        let alert = UIAlertController(title: "\(authType.rawValue) failed!", message: "Network failure. \(error.rawValue)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
//            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

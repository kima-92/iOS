//
//  SnackifyTests.swift
//  SnackifyTests
//
//  Created by macbook on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest
@testable import Snackify

class SnackifyTests: XCTestCase {
    
    //MARK: Properties
    private let networkManager = NetworkManager()
//    private let snackManager = SnackManager(networkManager: networkManager)
    
    private let loginVC = LoginViewController()
    private let snackTableVC = SnacksTableViewController()
    private let snackDetailVC = SnackDetailViewController()
    private let snacksOrderVC = SnacksOrderViewController()
    private let snacksMainVC = SnacksMainViewController()
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testFetchingSnacksFromSubs() {
        
    }
    
    func testGettingValidBearer() {
        
        let loginPromise = expectation(description: "Valid Bearer")
        
        networkManager.logIn(with: "user90", password: "user90", isOrganization: false) { (result) in
            do {
                let bearer = try result.get()
                print("Success! Bearer: \(bearer.token)")
                XCTAssertNotNil(bearer.token)
                
                loginPromise.fulfill()
            } catch {
                NSLog("Error loginng in: \(error)")
                XCTFail()
            }
        }

        
        sleep(5)
        wait(for: [loginPromise], timeout: 6)
        
    }
    
    func testSuccessfulEmployeeSignUp() {
        
        let signUpPromise = expectation(description: "Successful Sign Up")
        
        let user = User(username: "testingUser", password: "testingPassword", fullName: "test", email: "test", phoneNumber: "000-000-0000", streetAddress: "123 Street", state: "florida", zipCode: "55555", isAdmin: false, isOrganization: false)
        
        networkManager.signUp(with: user) { (result) in
            do {
                let _ = try result.get()
                signUpPromise.fulfill()
            } catch {
                if let error = error as? NetworkError {
                    NSLog("Error signing up: \(error.rawValue)")
                } else {
                    NSLog("Error signing up: \(error)")
                }
                return
            }
        }
        wait(for: [signUpPromise], timeout: 6)
    }
    

////    var networkManager: NetworkManager?
//        var authType = AuthType.logIn
//        var userType = UserType.employee
//
//        //MARK: Outlets
//        @IBOutlet weak var roleSegmentedControl: UISegmentedControl!
//        @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
//
//        @IBOutlet weak var usernameTextField: UITextField!
//        @IBOutlet weak var passwordTextField: UITextField!
//        @IBOutlet weak var fullNameTextField: UITextField!
//        @IBOutlet weak var emailTextField: UITextField!
//        @IBOutlet weak var phoneNumberTextField: UITextField!
//        @IBOutlet weak var addressTextField: UITextField!
//        @IBOutlet weak var stateTextField: UITextField!
//        @IBOutlet weak var zipcodeTextField: UITextField!
//        @IBOutlet weak var organizationTextField: UITextField!
//
//        @IBOutlet weak var loginButton: UIButton!
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            loginSegmentedControl.selectedSegmentIndex = 1
//    //        navigationItem.hidesBackButton = true
//            updateViews()
//        }
//
//        //MARK: Actions
//
//        @IBAction func roleSegmentedControlChanged(_ sender: UISegmentedControl) {
//            if sender.selectedSegmentIndex == 0 {
//                userType = .employee
//                updateViews()
//            } else {
//                userType = .organization
//                updateViews()
//            }
//        }
//
//        @IBAction func loginSegmentedControlChanged(_ sender: UISegmentedControl) {
//            if sender.selectedSegmentIndex == 0 {
//                authType = .signUp
//                updateViews()
//            } else {
//                authType = .logIn
//                updateViews()
//            }
//        }
//
//        @IBAction func loginButtonTapped(_ sender: UIButton) {
//
//            // Creating a user
//            guard let username = usernameTextField.text,
//                let password = passwordTextField.text,
//                username != "",
//                password != ""
//                else { return }
//
//            // perform login or sign up operation based on loginType
//            if authType == .signUp {
//                guard let fullname = fullNameTextField.text,
//                    let email = emailTextField.text,
//                    let phoneNum = phoneNumberTextField.text,
//                    let address = addressTextField.text,
//                    let state = stateTextField.text,
//                    let zipcode = zipcodeTextField.text,
//                    fullname != "",
//                    email != "",
//                    phoneNum != "",
//                    address != "",
//                    state != "",
//                    zipcode != ""
//                    else { return }
//                if !(userType == .organization) {
//                    guard let organization = organizationTextField.text,
//                        organization != ""
//                        else { return }
//                }
//                let user = User(username: username, password: password, fullName: fullname, email: email, phoneNumber: phoneNum, streetAddress: address, state: state, zipCode: zipcode, isAdmin: false, isOrganization: userType == .organization)
//                signUp(with: user)
//            } else {
//                logIn(username: username, password: password)
//            }
//        }
//
//        func signUp(with user: User) {
//            networkManager?.signUp(with: user, completion: { (result) in
//                do {
//                    let _ = try result.get()
//                } catch {
//                    if let error = error as? NetworkError {
//                        NSLog("Error signing up: \(error.rawValue)")
//                    } else {
//                        NSLog("Error signing up: \(error)")
//                    }
//                    return
//                }
//                let alert = UIAlertController(title: "Sign Up Successful!",
//                                              message: "Please log in",
//                                              preferredStyle: .alert)
//
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                alert.addAction(okAction)
//
//                DispatchQueue.main.async {
//                    self.present(alert, animated: true) {
//                        self.authType = .logIn
//                        self.updateViews()
//                    }
//                }
//            })
//        }
//
//        func logIn(username: String, password: String) {
//            networkManager?.logIn(with: username,
//                                  password: password,
//                                  isOrganization: userType == .organization
//            ) { result in
//                do {
//                    let bearer = try result.get()
//                    print("Success! Bearer: \(bearer.token)")
//
//                    DispatchQueue.main.async {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                } catch {
//                    NSLog("Error loginng in: \(error)")
//                }
//            }
//        }
//
//        func updateViews() {
//            loginButton.layer.cornerRadius = 8.0
//            passwordTextField.isSecureTextEntry = true
//
//            let authTypeIsLogin = (authType == .logIn)
//
//            loginSegmentedControl.selectedSegmentIndex = authTypeIsLogin ? 1 : 0
//            roleSegmentedControl.selectedSegmentIndex = (userType == UserType.organization) ? 1 : 0
//
//            fullNameTextField.isHidden = authTypeIsLogin
//            emailTextField.isHidden = authTypeIsLogin
//            phoneNumberTextField.isHidden = authTypeIsLogin
//            addressTextField.isHidden = authTypeIsLogin
//            stateTextField.isHidden = authTypeIsLogin
//            zipcodeTextField.isHidden = authTypeIsLogin
//            organizationTextField.isHidden = authTypeIsLogin || userType.isAdmin
//
//            fullNameTextField.isEnabled = !authTypeIsLogin
//            emailTextField.isEnabled = !authTypeIsLogin
//            phoneNumberTextField.isEnabled = !authTypeIsLogin
//            addressTextField.isEnabled = !authTypeIsLogin
//            stateTextField.isEnabled = !authTypeIsLogin
//            zipcodeTextField.isEnabled = !authTypeIsLogin
//            organizationTextField.isEnabled = !(authTypeIsLogin || userType.isAdmin)
//
//            loginButton.setTitle((authTypeIsLogin ? "Log In" : "Sign Up"), for: .normal)
//
//            fullNameTextField.placeholder = (userType == .organization) ? "Organization Name" : "Full Name"
//        }
//
//
//
//
//
//
//
//
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

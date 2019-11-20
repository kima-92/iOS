//
//  SnackifyUITests.swift
//  SnackifyUITests
//
//  Created by macbook on 11/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest

class SnackifyUITests: XCTestCase {
    
    //MARK: Properties
    var app = XCUIApplication()

    override func setUp() {
        super.setUp()
                  
                  continueAfterFailure = false
                  app = XCUIApplication()
                  
//                  app.launchArguments = ["UITesting"]
                  app.launch()
    }
    
    func testRegisteringAnOrganization() {
        
        app/*@START_MENU_TOKEN@*/.buttons["Organization"]/*[[".segmentedControls.buttons[\"Organization\"]",".buttons[\"Organization\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".segmentedControls.buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        signUpButton.tap()
        
        let usernameTextField = app.staticTexts["usernameTextField"]
        usernameTextField.tap()
        usernameTextField.typeText("Company 1")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("company1")
//        passwordSecureTextField.tap()
        
        let fullNameTextField = app.textFields["Full Name"]
        fullNameTextField.tap()
        fullNameTextField.typeText("company1")
//        fullNameTextField.tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("company1@gmail.com")
//        emailTextField.tap()
        
        let phoneNumberTextField = app.textFields["Phone Number"]
        phoneNumberTextField.tap()
        phoneNumberTextField.typeText("000-000-0000")
//        phoneNumberTextField.tap()
        
        let streetAddressTextField = app.textFields["Street Address"]
        streetAddressTextField.tap()
        streetAddressTextField.typeText("123 Street")
//        streetAddressTextField.tap()
        
        streetAddressTextField.swipeUp()
        streetAddressTextField.swipeUp()
        streetAddressTextField.swipeUp()
        
        let stateTextField = app.textFields["State"]
        stateTextField.tap()
        stateTextField.typeText("florida")
//        stateTextField.tap()
        
        let zipcodeTextField = app.textFields["Zipcode"]
        zipcodeTextField.tap()
        zipcodeTextField.typeText("55555")
//        zipcodeTextField.tap()
        
        let organizationTextField = app.textFields["Organization"]
        organizationTextField.tap()
        organizationTextField.typeText("company1")
//        organizationTextField.tap()
        
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Sign Up"]/*[[".buttons.matching(identifier: \"Sign Up\").staticTexts[\"Sign Up\"]",".staticTexts[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
//        XCTAssertEqual(app.alerts["Sign Up Successful!"].title, "Sign Up Successful!")
        XCTAssertTrue(app.alerts["Sign Up Successful!"].waitForExistence(timeout: 5))
        
        app.alerts["Sign Up Successful!"].scrollViews.otherElements.buttons["OK"].tap()
        
        XCTAssertEqual(app.segmentedControls.buttons["Log In"].title, "Log In")
        XCTAssertEqual(app.buttons["Log In"].title, "Log In")
        
        
        // TODO: Add this to the LoginVC :
        
//        usernameTextField.accessibilityIdentifier = "usernameTextField"
//        passwordTextField.accessibilityIdentifier = "passwordTextField"
//        fullNameTextField.accessibilityIdentifier = "fullNameTextField"
//        emailTextField.accessibilityIdentifier = "emailTextField"
//        phoneNumberTextField.accessibilityIdentifier = "phoneNumberTextField"
//        addressTextField.accessibilityIdentifier = "addressTextField"
//        stateTextField.accessibilityIdentifier = "stateTextField"
//        zipcodeTextField.accessibilityIdentifier = "zipcodeTextField"
//        organizationTextField.accessibilityIdentifier = "organizationTextField"
        
//        @IBOutlet weak var welcomeLabel: UILabel!
//        @IBOutlet weak var deadlineLabel: UILabel!
        
//        welcomeLabel.accessibilityIdentifier = "welcomeUserLabel"
//        deadlineLabel.accessibilityIdentifier = "dealineLabel"

//        If this works for userName, I should use "statict text for everything else like :
//        let usernameTextField = app.staticTexts["usernameTextField"]

    
    }
    
    func testLogInAnEmployee() {
        
    }
    
    func testDisplayingSnacksList() {
        
        app/*@START_MENU_TOKEN@*/.buttons["Employee"]/*[[".segmentedControls.buttons[\"Employee\"]",".buttons[\"Employee\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.segmentedControls.buttons["Log In"].tap()
        
//        app.textFields["Username"].tap()
        
        let usernameTextField = app.staticTexts["usernameTextField"]
        usernameTextField.tap()
        usernameTextField.typeText("user90")
        
//        app.secureTextFields["passwordTextField"].tap()
        
        let passwordTextField = app.staticTexts["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("user90")
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons.matching(identifier: \"Log In\").staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Available Snacks"].tap()
        
        XCTAssertNotNil(app.tableRows)
        XCTAssertNotNil(app.tableColumns)

    }
    

        func testSubsDeadlineIsNotBlank() {
            
            app.buttons["Employee"].tap()
            app.segmentedControls.buttons["Log In"].tap()
            
    //        app.textFields["Username"].tap()
            
            let usernameTextField = app.staticTexts["usernameTextField"]
            usernameTextField.tap()
            usernameTextField.typeText("user90")
            
    //        app.secureTextFields["passwordTextField"].tap()
            
            let passwordTextField = app.staticTexts["passwordTextField"]
            passwordTextField.tap()
            passwordTextField.typeText("user90")
            
            app.staticTexts["Log In"].tap()
            
            XCTAssertNotEqual(app.staticTexts["deadlineLabel"].title, "00/00/0000")
            XCTAssertNotEqual(app.staticTexts["welcomeLabel"].title, "Welcome User!")
            
            
            
        }
    
    
    
    
    
    
    
    
    //    func testLaunchPerformance() {
    //        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
    //            // This measures how long it takes to launch your application.
    //            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
    //                XCUIApplication().launch()
    //            }
    //        }
    //    }
}

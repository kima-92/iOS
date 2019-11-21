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
    
    func testFetchingSnacksOption() {
        
        let fetchingSnacksOptionsPromise = expectation(description: "Got Snacks options")
        var snacks: [Snack] = []
        
        let snackManager = SnackManager(networkManager: networkManager)
        
        snackManager.fetchSnackOptions { (result) in
            do {
                snacks = try result.get()
                
                fetchingSnacksOptionsPromise.fulfill()
            } catch {
                NSLog((error as? NetworkError)?.rawValue ?? "")
                return
            }
            
        }
        wait(for: [fetchingSnacksOptionsPromise], timeout: 6)
        XCTAssertNotNil(snacks)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

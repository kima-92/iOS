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

    
    
    
    
    
    
    
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

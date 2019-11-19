//
//  SnacksMainViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksMainViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var placeNewOrderButton: UIButton!
    @IBOutlet weak var NextOrderDeadlineLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: Actions
    @IBAction func LogOutButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

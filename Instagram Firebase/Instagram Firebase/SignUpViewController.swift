//
//  SignUpViewController.swift
//  Instagram Firebase
//
//  Created by Chidi Emeh on 6/6/17.
//  Copyright © 2017 Chidi Emeh. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Welcome Sign Up ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Sign up was removed from memory")
    }
}

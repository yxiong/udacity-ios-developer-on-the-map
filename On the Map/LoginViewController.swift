//
//  ViewController.swift
//  On the Map
//
//  Created by Ying Xiong on 10/24/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonClicked(sender: AnyObject) {
        print("Email: ", emailTextField.text)
        print("Passord: ", passwordTextField.text)
    }

}


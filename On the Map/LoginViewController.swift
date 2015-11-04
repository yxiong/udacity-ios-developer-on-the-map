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
    @IBOutlet weak var errorInfoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorInfoTextField.text = ""
    }

    @IBAction func loginButtonClicked(sender: AnyObject) {
        // Make sure email and password are not empty.
        guard (!emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) else {
            errorInfoTextField.text! = "Email and/or password field is empty."
            return
        }
        OnTheMapModel.sharedInstance().login(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) -> Void in
            guard success else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.errorInfoTextField.text = errorString
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.errorInfoTextField.text = ""
                let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                self.presentViewController(tabBarController, animated: true, completion: nil)
            })

        }
    }
}


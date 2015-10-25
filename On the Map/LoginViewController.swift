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
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty) {
            print("Email and/or password field is empty.")
            return
        }
        let methodParameters: [String: String!] = [
            "username": emailTextField.text,
            "password": passwordTextField.text
        ]
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"ying@xiongs.org\", \"password\":\"******\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print(error)
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length-5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        print("Email: ", emailTextField.text)
        print("Passord: ", passwordTextField.text)
    }
}


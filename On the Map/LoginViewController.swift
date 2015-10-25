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
        guard (!emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) else {
            errorInfoTextField.text! = "Email and/or password field is empty."
            return
        }
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSString(format: "{\"udacity\": {\"username\": \"%@\", \"password\":\"%@\"}}", emailTextField.text!, passwordTextField.text!).dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                print("Error returned by request", error)
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length-5))
            let parsedResult = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            guard parsedResult.objectForKey("error") == nil else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.errorInfoTextField.text! = parsedResult.objectForKey("error")! as! String
                })
                return
            }
            print(parsedResult)
        }
        task.resume()
    }
}


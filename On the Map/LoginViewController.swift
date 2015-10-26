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
    
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorInfoTextField.text = ""
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    @IBAction func loginButtonClicked(sender: AnyObject) {
        // Make sure email and password are not empty.
        guard (!emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) else {
            errorInfoTextField.text! = "Email and/or password field is empty."
            return
        }
        // Create a request object.
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSString(format: "{\"udacity\": {\"username\": \"%@\", \"password\":\"%@\"}}", emailTextField.text!, passwordTextField.text!).dataUsingEncoding(NSUTF8StringEncoding)
        // Submit the request with a session.
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            // Error checking of response.
            guard error == nil else {
                print("Error returned by request", error)
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            // Handling special format of response data (skipping the first 5 characters).
            let newData = data.subdataWithRange(NSMakeRange(5, data.length-5))
            // Parse the returned data.
            let parsedResult = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            // Present any error to user, mostly because of the bad credentials.
            guard parsedResult.objectForKey("error") == nil else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.errorInfoTextField.text = (parsedResult.objectForKey("error")! as! String)
                })
                return
            }
            // Now we successfully logged in, record the account key and session id, and then redirect to map view.
            dispatch_async(dispatch_get_main_queue(), {
                self.errorInfoTextField.text = ""
                self.appDelegate.accountKey = ((parsedResult["account"] as! [String: AnyObject])["key"] as! String)
                self.appDelegate.sessionId = ((parsedResult["session"] as! [String: AnyObject])["id"] as! String)
                let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                self.presentViewController(tabBarController, animated: true, completion: nil)
            })
        }
        task.resume()
    }
}


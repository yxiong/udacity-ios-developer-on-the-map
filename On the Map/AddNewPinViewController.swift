//
//  AddNewPinViewController.swift
//  On the Map
//
//  Created by Ying Xiong on 11/1/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import Foundation
import UIKit

class AddNewPinViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func findButtonPushed(sender: AnyObject) {
        print("Finding: " + locationTextField.text!)
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
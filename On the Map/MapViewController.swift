//
//  MapViewController.swift
//  On the Map
//
//  Created by Ying Xiong on 10/25/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print("Account Key:", appDelegate.accountKey)
        print("Session ID:", appDelegate.sessionId)
    }
}
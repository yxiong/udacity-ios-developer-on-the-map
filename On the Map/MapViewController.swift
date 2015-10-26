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
        
        // Retrieve student location data through parse.com
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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

            print(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }

    func getUserData() {

        let request = NSMutableURLRequest(URL: NSURL(string: NSString(format: "https://www.udacity.com/api/users/%@", appDelegate.accountKey!) as String)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in// Error checking of response.
            guard error == nil else {
                print("Error returned by request", error)
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            // Handling special format of response data (skipping the first 5 characters).
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}
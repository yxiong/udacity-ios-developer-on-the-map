//
//  AddNewPinViewController.swift
//  On the Map
//
//  Created by Ying Xiong on 11/1/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class AddNewPinViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var placemark: MKPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.enabled = false
    }
    
    @IBAction func findButtonPushed(sender: AnyObject) {
        guard locationTextField.text != "" else {
            let alert = UIAlertController(title: "Error", message: "Must enter a location.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = locationTextField.text
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({(response, error) in
            
            guard error == nil else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            guard response!.mapItems.count > 0 else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = UIAlertController(title: "Error", message: "No Match Found.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.placemark = response!.mapItems[0].placemark
                self.mapView.addAnnotation(self.placemark)
                let region = MKCoordinateRegionMakeWithDistance(self.placemark.coordinate, 100000, 100000)
                self.mapView.setRegion(region, animated: true)
                self.submitButton.enabled = true
            })
        })
    }
    
    @IBAction func submitButtonPushed(sender: AnyObject) {
        guard linkTextField.text != "" else {
            let alert = UIAlertController(title: "Error", message: "Must enter a link.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSString(format: "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"%@\", \"mediaURL\": \"%@\",\"latitude\": %f, \"longitude\": %f}", locationTextField.text!, linkTextField.text!, self.placemark.coordinate.latitude, self.placemark.coordinate.longitude).dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                print("Error returned by request", error)
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
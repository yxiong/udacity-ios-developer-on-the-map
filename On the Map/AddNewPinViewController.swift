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
        OnTheMapModel.sharedInstance().addNewAnnotationAndSubmit(locationTextField.text!, mediaURL: linkTextField.text!, placemark: self.placemark) { () -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
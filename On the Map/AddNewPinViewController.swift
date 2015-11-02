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
    @IBOutlet weak var mapView: MKMapView!
    
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
            
            let item = response!.mapItems[0]
            self.mapView.addAnnotation(item.placemark)
        })
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
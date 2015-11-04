//
//  OnTheMapModel.swift
//  On the Map
//
//  Created by Ying Xiong on 11/3/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import Foundation
import MapKit

class OnTheMapModel: NSObject {
    var annotations: [MKPointAnnotation]
    
    override init() {
        annotations = [MKPointAnnotation]()
    }
    
    func loadAnnotations(completionHandler: (annotations: [MKPointAnnotation]) -> Void) {
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
            let parsedResult = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            let resultsArray = parsedResult.objectForKey("results") as! [NSDictionary]
            self.annotations.removeAll()
            for dictionary in resultsArray {
                let annotation = MKPointAnnotation()
                
                let latitude = CLLocationDegrees(dictionary.objectForKey("latitude")! as! Double)
                let longitude = CLLocationDegrees(dictionary.objectForKey("longitude")! as! Double)
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                let firstName = dictionary.objectForKey("firstName") as! String
                let lastName = dictionary.objectForKey("lastName") as! String
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = (dictionary.objectForKey("mediaURL") as! String)
                
                self.annotations.append(annotation)
            }
            completionHandler(annotations: self.annotations)
        }
        task.resume()
    }
    
    class func sharedInstance() -> OnTheMapModel {
        struct Singleton {
            static var sharedInstance = OnTheMapModel()
        }
        return Singleton.sharedInstance
    }
}
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
    
    func login(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        // Create a request object.
        let urlString = "https://www.udacity.com/api/session"
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSString(format: "{\"udacity\": {\"username\": \"%@\", \"password\":\"%@\"}}", email, password).dataUsingEncoding(NSUTF8StringEncoding)
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
                completionHandler(success: false, errorString: (parsedResult.objectForKey("error")! as! String))
                return
            }
            // Now we successfully logged in, record the account key and session id, and then redirect to map view.
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    func loadAnnotations(completionHandler: () -> Void) {
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
            completionHandler()
        }
        task.resume()
    }
    
    func addNewAnnotationAndSubmit(mapString: String, mediaURL: String, placemark: MKPlacemark, completionHandler: () -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSString(format: "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"%@\", \"mediaURL\": \"%@\",\"latitude\": %f, \"longitude\": %f}", mapString, mediaURL, placemark.coordinate.latitude, placemark.coordinate.longitude).dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                print("Error returned by request", error)
                return
            }
            let annotation = MKPointAnnotation()
            annotation.title = mapString
            annotation.subtitle = mediaURL
            annotation.coordinate = placemark.coordinate
            self.annotations.insert(annotation, atIndex: 0)
            completionHandler()
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
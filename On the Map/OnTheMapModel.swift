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
    var accountKey: String?
    var userFirstName: String?
    var userLastName: String?
    var sessionId: String?
    var studentInfos: [StudentInfo]
    
    override init() {
        studentInfos = [StudentInfo]()
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
                completionHandler(success: false, errorString: error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
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
            let accountKey = ((parsedResult["account"] as! [String: AnyObject])["key"] as! String)
            self.sessionId = ((parsedResult["session"] as! [String: AnyObject])["id"] as! String)
            self.getUserData(accountKey, completionHandler: { (success, errorString) -> Void in
                if (success) {
                    self.loadStudentInfos({ (success, errorString) -> Void in
                        completionHandler(success: success, errorString: errorString)
                    })
                } else {
                    completionHandler(success: false, errorString: errorString)
                }
            })
        }
        task.resume()
    }
    
    
    func getUserData(accountKey: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: NSString(format: "https://www.udacity.com/api/users/%@", accountKey) as String)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in// Error checking of response.
            guard error == nil else {
                completionHandler(success: false, errorString: error?.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }
            // Handling special format of response data (skipping the first 5 characters).
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            let parsedResult = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            self.userFirstName = ((parsedResult["user"] as! [String: AnyObject])["first_name"] as! String)
            self.userLastName = ((parsedResult["user"] as! [String: AnyObject])["last_name"] as! String)
            self.accountKey = accountKey
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    func logout() {
        accountKey = nil
        userFirstName = nil
        userLastName = nil
        sessionId = nil
    }
    
    func loadStudentInfos(completionHandler: (success: Bool, errorString: String?) -> Void) {
        // Retrieve student location data through parse.com
        let parameters = ["order": "-updatedAt"]
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation" + OnTheMapModel.escapedParameters(parameters))!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completionHandler(success: false, errorString: error?.description)
                return
            }
            guard let data = data else {
                completionHandler(success: false, errorString: "No data was returned by the request!")
                return
            }
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                completionHandler(success: false, errorString: "Not able to parse result from server!")
                return
            }
            let resultsArray = parsedResult.objectForKey("results") as? [NSDictionary]
            guard resultsArray != nil else {
                completionHandler(success: false, errorString: "Server error: unparseable results array.")
                return
            }
            self.studentInfos.removeAll()
            for dictionary in resultsArray! {
                let latitude = CLLocationDegrees(dictionary.objectForKey("latitude")! as! Double)
                let longitude = CLLocationDegrees(dictionary.objectForKey("longitude")! as! Double)
                
                let firstName = dictionary.objectForKey("firstName") as! String
                let lastName = dictionary.objectForKey("lastName") as! String
                let linkUrl = dictionary.objectForKey("mediaURL") as! String

                self.studentInfos.append(StudentInfo(dictionary: ["firstName": firstName, "lastName": lastName, "linkUrl": linkUrl, "latitude": latitude, "longitude": longitude]))
            }
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    func addNewStudentInfoAndSubmit(mapString: String, mediaURL: String, placemark: MKPlacemark, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSString(format: "{\"uniqueKey\": \"%@\", \"firstName\": \"%@\", \"lastName\": \"%@\",\"mapString\": \"%@\", \"mediaURL\": \"%@\",\"latitude\": %f, \"longitude\": %f}", accountKey!, userFirstName!, userLastName!, mapString, mediaURL, placemark.coordinate.latitude, placemark.coordinate.longitude).dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completionHandler(success: false, errorString: error?.description)
                return
            }
            let studentInfo = StudentInfo(dictionary: ["firstName": self.userFirstName!, "lastName": self.userLastName!, "linkUrl": mediaURL, "latitude": placemark.coordinate.latitude, "longitude": placemark.coordinate.longitude])
            self.studentInfos.insert(studentInfo, atIndex: 0)
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
    }
    
    class func sharedInstance() -> OnTheMapModel {
        struct Singleton {
            static var sharedInstance = OnTheMapModel()
        }
        return Singleton.sharedInstance
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}
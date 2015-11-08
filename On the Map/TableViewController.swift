//
//  TableViewController.swift
//  On the Map
//
//  Created by Ying Xiong on 11/3/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class TableViewController: UITableViewController {
    var annotations: [MKPointAnnotation] {
        return OnTheMapModel.sharedInstance().annotations
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annotations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MapPinCell")!
        let annotation = annotations[indexPath.row]
        cell.textLabel?.text = annotation.title
        cell.detailTextLabel?.text = annotation.subtitle
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        let annotation = annotations[indexPath.row]
        if let toOpen = annotation.subtitle {
            app.openURL(NSURL(string: toOpen)!)
        }
    }
    
    @IBAction func refreshButtonPushed(sender: AnyObject) {
        OnTheMapModel.sharedInstance().loadAnnotations { () -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func logoutButtonPushed(sender: AnyObject) {
        OnTheMapModel.sharedInstance().logout()
        let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginController, animated: true, completion: nil)
    }
}
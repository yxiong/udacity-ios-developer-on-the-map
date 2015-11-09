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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnTheMapModel.sharedInstance().studentInfos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MapPinCell")!
        let studentInfo = OnTheMapModel.sharedInstance().studentInfos[indexPath.row]
        cell.textLabel?.text = studentInfo.fullName()
        cell.detailTextLabel?.text = studentInfo.linkUrl
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentInfo = OnTheMapModel.sharedInstance().studentInfos[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: studentInfo.linkUrl)!)
    }
    
    @IBAction func refreshButtonPushed(sender: AnyObject) {
        OnTheMapModel.sharedInstance().loadStudentInfos { (success, errorString) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func logoutButtonPushed(sender: AnyObject) {
        OnTheMapModel.sharedInstance().logout()
        let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginController, animated: true, completion: nil)
    }
}
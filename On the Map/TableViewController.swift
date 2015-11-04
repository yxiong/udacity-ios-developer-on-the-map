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
}
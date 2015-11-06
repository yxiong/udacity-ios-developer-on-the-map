//
//  StudentInfo.swift
//  On the Map
//
//  Created by Ying Xiong on 11/5/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import Foundation

struct StudentInfo {
    var accountKey = ""
    var firstName = ""
    var lastName = ""

    init(dictionary: [String: AnyObject]) {
        accountKey = dictionary["accountKey"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
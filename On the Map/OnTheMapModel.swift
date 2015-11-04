//
//  OnTheMapModel.swift
//  On the Map
//
//  Created by Ying Xiong on 11/3/15.
//  Copyright © 2015 Ying Xiong. All rights reserved.
//

import Foundation

class OnTheMapModel: NSObject {
    class func sharedInstance() -> OnTheMapModel {
        struct Singleton {
            static var sharedInstance = OnTheMapModel()
        }
        return Singleton.sharedInstance
    }
}
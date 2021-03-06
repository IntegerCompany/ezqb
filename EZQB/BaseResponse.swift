//
//  BaseResponse.swift
//  EZQB
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import Foundation

class BaseResponse : JSONSerializable {
    
    var status: String!
    var error: String?
    
    var success: Bool {
        return status == "ok"
    }
    
    required init(json: NSDictionary) {
        
        self.status = json.valueForKey("status") as! String
        self.error = json.valueForKey("error") as? String
    }
}

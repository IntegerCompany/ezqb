//
//  NonceResponse.swift
//  EZQB
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import Foundation

class NonceResponse: BaseResponse {
    
    var nonce: String?
    
    required init(json: NSDictionary) {
        
        self.nonce = json.valueForKey("nonce") as? String
        
        super.init(json: json)
    }
}
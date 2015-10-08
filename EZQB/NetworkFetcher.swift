//
//  NetworkFetcher.swift
//  EZQB
//
//  Created by RomanSorochak on 05.08.15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import Foundation

class NetworkFetcher {
    
    class func executeURL(url: NSURL,
        withCompletion completion: ((data: NSData?, error: NSError?)->Void)) {
            
            executeURLRequest(NSURLRequest(URL: url),
                withCompletion: { (data, error) -> Void in
                    
                    self.log(data)
                    
                    completion(data: data, error: error)
            })
    }
    
    class func executeURLRequest(request: NSURLRequest,
        withCompletion completion: ((data: NSData?, error: NSError?)->Void)) {
            
            NSURLSession.sharedSession().dataTaskWithRequest(request,
                completionHandler: { (data, response, error) -> Void in
                    
                    self.log(data)
                    
                    completion(data: data, error: error)
            }).resume()
    }
    
    class func uploadDataWithURLRequest(request: NSURLRequest, data: NSData!, withCompletion
        completion: (data: NSData?, response:NSURLResponse!, error: NSError?) ->Void) {
            
            NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: data) {
                (data, response, error) -> Void in
                
                self.log(data)
                
                completion(data: data, response: response, error: error)
                }.resume()
    }
    
    
    //MARK: for testing
    private class func log(data: NSData?) {
        if data == nil {
            print("data is nil")
        } else {
            do {
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data!,
                options: NSJSONReadingOptions())
                print(dictionary)
            }catch _ {
                print("Cant generate json object")
            }
        }
    }
}

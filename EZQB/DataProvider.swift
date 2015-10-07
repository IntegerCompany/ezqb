//
//  DataProvider.swift
//  EZQB
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class DataProvider {
    
    class func loginWithEmail(email: String, password: String,
        completion: ((response: BaseResponse?, error: NSError?)->Void)) {
            
            showStatusBarActivityIndicator()
            
            ServiceApi.getNonceWithCompletion {
                (nonce, error) -> Void in
                
                if error == nil
                    &&
                    nonce != nil {
                        
                        ServiceApi.loginWithNonce(nonce!.nonce!,
                            email: email,
                            password: password,
                            completion: { (response, error) -> Void in
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.hideStatusBarActivityIndicator()
                                    completion(response: response, error: error)
                                })
                        })
                } else {
                    
                    completion(response: nil, error: error)
                }
            }
    }
    
    class func resetPasswordWithEmail(email: String,
        completion: ((response: BaseResponse?, error: NSError?)->Void)) {
            
            showStatusBarActivityIndicator()
            
            ServiceApi.resetPasswordWithEmail(email,
                completion: { (response, error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hideStatusBarActivityIndicator()
                        completion(response: response, error: error)
                    })
            })
    }
    
    class func registerWithUserName(userName: String, email: String,
        password: String, completion: ((response: BaseResponse?, error: NSError?)->Void)) {
            
            showStatusBarActivityIndicator()
            
            ServiceApi.getNonceWithCompletion {
                (nonce, error) -> Void in
                
                if error == nil
                    &&
                    nonce != nil {
                        
                        ServiceApi.registerWithUserName(userName,
                            email: email,
                            nonce: nonce!.nonce!,
                            password: password,
                            completion: { (response, error) -> Void in
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.hideStatusBarActivityIndicator()
                                    completion(response: response, error: error)
                                })
                        })
                } else {
                    
                    completion(response: nil, error: error)
                }
            }
    }
    
    class func uploadPhoto(image: UIImage, withName name: String, completion: ((error: NSError?)->Void)) {
        
        ServiceImageUploader.uploadImage(image,
            withName: name) { (data, response, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    completion(error: error)
                })
        }
    }
    
    
    // MARK - private
    
    private class func showStatusBarActivityIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    private class func hideStatusBarActivityIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

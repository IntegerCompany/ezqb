//
//  ServiceApi.swift
//  EZQB
//
//  Created by iOS Developer on 7/27/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import Foundation

class ServiceApi {
    
    private static let BaseURL = "http://ezquickbooksonline.com/api"
    
    
    // MARK - public
    
    class func getNonceWithCompletion(completion:
        ((nonce: NonceResponse?, error: NSError?)->Void)) {
            
            let url: NSURL = NSURL(string: BaseURL + pathGetNonce())!
            
            NetworkFetcher.executeURL(url,
                withCompletion: { (data, error) -> Void in
                    
                    var nonce: NonceResponse?
                    
                    if error == nil {
                        do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            nonce = NonceResponse(json: json)
                            completion(nonce: nonce, error: error)
                        }catch _ {
                            print("Error responce : \(error)")
                        }
                    }
            })
    }
    
    class func loginWithNonce(nonce: String,
        email: String,
        password: String,
        completion: ((response: BaseResponse?, error: NSError?)->Void)) {
            
            let url: NSURL = NSURL(
                string: BaseURL + pathLoginPathWithNonce(nonce, userName: email, password: password)
                )!
//            let request: NSURLRequest = NSURLRequest(URL: url)
//            
            NetworkFetcher.executeURL(url,
                withCompletion: { (data, error) -> Void in
                    
                    var response: BaseResponse?
                    
                    if error == nil {
                        do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            response = BaseResponse(json: json)
                        }catch _ {
                            print("BaseResponse : Can't generate json file")
                        }
                    }
                    
                    completion(response: response, error: error)
            })
    }
    
    class func resetPasswordWithEmail(email: String,
        completion: ((response: BaseResponse?, error: NSError?)->Void)) {
            
            let url: NSURL = NSURL(
                string: BaseURL + pathResetPasswordWithEmail(email)
                )!
            
            NetworkFetcher.executeURL(url,
                withCompletion: { (data, error) -> Void in
                    
                    var response: BaseResponse?
                    
                    if error == nil {
                        do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                            response = BaseResponse(json: json)
                        }catch _{
                            print("BaseResponse : Can't generate json file")
                        }
                    }
                    
                    completion(response: response, error: error)
            })
    }
    
    class func registerWithUserName(userName: String, email: String, nonce: String,
        password: String, completion: ((response: BaseResponse?, error: NSError?)->Void)) {
            
            let url: NSURL = NSURL(
                string: BaseURL + pathRegisterWithUserName(userName, email: email,
                    nonce: nonce, password: password)
                )!
            
            NetworkFetcher.executeURL(url,
                withCompletion: { (data, error) -> Void in
                    
                    var response: BaseResponse?
                    
                    if error == nil {
                        do{
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        response = BaseResponse(json: json)
                        }catch _ {
                           print("BaseResponse : Can't generate json file")
                        }
                    }
                    
                    completion(response: response, error: error)
            })
    }
    
    
    // MARK - private
    
    private class func pathGetNonce() -> String {
        
        return "/get_nonce/?controller=user&method=registers"
    }
    
    private class func pathLoginPathWithNonce(nonce: String, userName: String,
        password: String) -> String {
            
            return "/auth/generate_auth_cookie/?nonce=\(nonce)&username=\(userName)&password=\(password)"
    }
    
    private class func pathResetPasswordWithEmail(email: String) -> String {
        
        return "/user/retrieve_password/?user_login=\(email)"
    }
    
    private class func pathRegisterWithUserName(userName: String, email: String, nonce: String,
        password: String) -> String {
            
           return "/user/registers/?username=\(userName)&email=\(email)&nonce=\(nonce)&display_name=\(userName)&user_pass=\(password)"
    }
}

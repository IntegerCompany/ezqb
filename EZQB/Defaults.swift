//
//  Defaults.swift
//  EZQB
//
//  Created by Roman Sorochak on 29.07.15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import Foundation

class Defaults {
  
  private static let Email = "EMAIL"
  private static let Password = "PASSWORD"
  private static let UserId = "USER_ID"
  
  class func setEmail(email: String, andPassword password: String) {
    
    NSUserDefaults.standardUserDefaults().setObject(email,
      forKey: Defaults.Email
    )
    NSUserDefaults.standardUserDefaults().setObject(password,
      forKey: Defaults.Password
    )
  }
  
  class func setUserId(userId : Int){
    NSUserDefaults.standardUserDefaults().setObject(userId,
      forKey: Defaults.UserId
    )
  }
  
  class func getUserId() -> (Int){
    let userId = NSUserDefaults.standardUserDefaults().integerForKey(Defaults.UserId)
    return userId
  }
  
  class func getEmailAndPassword() -> (email: String, password: String)? {
    
    if let email = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.Email),
      let password = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.Password){
        return (email, password)
    }else{
      return nil
    }
    
  }
  
  class func resetEmailAndPassword() {
    
    let appDomain: NSString = NSBundle.mainBundle().bundleIdentifier!
    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain as String)
  }
}

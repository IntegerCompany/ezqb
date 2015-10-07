//
//  Defaults.swift
//  EZQB
//
//  Created by Roman Sorochak on 29.07.15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import Foundation

class Defaults {
    
    private static let EMAIL = "EMAIL"
    private static let PASSWORD = "PASSWORD"
    
    class func setEmail(email: String, andPassword password: String) {
        
        NSUserDefaults.standardUserDefaults().setObject(email,
            forKey: Defaults.EMAIL
        )
        NSUserDefaults.standardUserDefaults().setObject(password,
            forKey: Defaults.PASSWORD
        )
    }
    
    class func getEmailAndPassword() -> (email: String, password: String)? {
        
        let email = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.EMAIL)
        let password = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.PASSWORD)
        
        if email == nil
            ||
            password == nil {
                
                return nil
        }
        return (email!, password!)
    }
    
    class func resetEmailAndPassword() {
        
        let appDomain: NSString = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain as String)
    }
}

//
//  AddRemoveObservers.swift
//  EZQB
//
//  Created by Severyn-Vsewolod Katolyk on 8/7/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class Observers: NSObject {
    
    //romanso: when create func it would be better to put each param per one line (but it is discussable)
    class func addObservers(viewController: UIViewController, withshowKBString showKBString: String, andhideKBString hideKBString: String) {
        
        NSNotificationCenter.defaultCenter().addObserver(viewController,
            selector: Selector(showKBString),
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        NSNotificationCenter.defaultCenter().addObserver(viewController,
            selector: Selector(hideKBString),
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    class func removeObservers(viewController: UIViewController) {
        NSNotificationCenter.defaultCenter().removeObserver(viewController)
    }
}

//
//  KeyboardActions.swift
//  EZQB
//
//  Created by Severyn-Vsewolod Katolyk on 8/7/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class KeyboardActions: UIView {
    
    class func keyboardWillShow(notification: NSNotification, scrollViewBottomConstraint: NSLayoutConstraint, scrollView: UIScrollView) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]
                as? NSValue)?.CGRectValue() {
                    
                    scrollViewBottomConstraint.constant = keyboardSize.height
                    scrollView.alwaysBounceVertical = true
                    scrollView.scrollEnabled = true
            }
        }
    }
    
    class func keyboardWillHide(scrollViewBottomConstraint: NSLayoutConstraint, scrollView: UIScrollView) {
        
        scrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: false)
        scrollViewBottomConstraint.constant = 0
        scrollView.alwaysBounceVertical = false
        scrollView.scrollEnabled = false
    }
}
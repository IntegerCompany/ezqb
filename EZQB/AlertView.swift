//
//  AlertView.swift
//  EZQB
//
//  Created by Severyn-Vsewolod Katolyk on 8/1/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

//romanso: i don't see code for forgot password here 
//why ?
//i think it would be better to have appropriate code for forgot sword here
// in that case you should give this class better name such a ForgotPasswordAlertView (it is discussable)

// skatolyk: I don't think so
class AlertView: UIView {
    
    override func awakeFromNib() {

        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    class func showAlert(viewController: UIViewController, title: String, message: String, buttonTitle: String) {
        
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(
            UIAlertAction(title: buttonTitle,
                style: .Default,
                handler: nil
            )
        )
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}
//
//  UserLoginTextField.swift
//  EZQB
//
//  Created by Severyn-Vsewolod Katolyk on 8/1/15.
//  Copyright (c) 2015 iOS Developer. All rights reserved.
//

import UIKit

class UserLoginTextField: UITextField {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2

        self.layer.borderColor = UIColor(red: 236.0/255.0,
            green: 190.0/255.0,
            blue: 87.0/255.0,
            alpha: 1.0
            ).CGColor
    }
}

//
//  UploadImageCell.swift
//  EZQB
//
//  Created by Richard Turton on 13/04/2015.
//  Copyright (c) 2015 Richard turton. All rights reserved.
//

import UIKit

class UploadImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //romanso: think about
        //you can do it on storuboard
        //think which case you need to do that via code
        
        // skatolyk: How can I do it??
        self.imageView.userInteractionEnabled = true        
        self.imageView.layer.cornerRadius = 20
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = UIColor.grayColor().CGColor
        self.imageView.clipsToBounds = true
    }
}

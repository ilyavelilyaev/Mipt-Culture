//
//  DescriptionScrollView.swift
//  Mipt Culture
//
//  Created by гость on 20.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import UIKit

class TextViewShadow: UIView {

    override func drawRect(rect: CGRect) {
        let shadowPath = UIBezierPath(rect: bounds)
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0, 5)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.CGPath
    }
}

//
//  UIColor.swift
//  NewsFeedDigest
//
//  Created by lucas lima on 6/16/17.
//  Copyright © 2017 lucaslimapoa. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        precondition(
            0...255 ~= r &&
            0...255 ~= g &&
            0...255 ~= b &&
            0...1.0 ~= a, "r, g and b values must be within 0...255 range. Alpha must be between 0 and 1."
        )
        
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
    
}

//
//  Extention.swift
//  CircleAnimation
//
//  Created by Viral Chauhan on 03/01/18.
//  Copyright © 2018 Viral Chauhan. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb (r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroudColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 29, b: 49)
    static let pulsingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}

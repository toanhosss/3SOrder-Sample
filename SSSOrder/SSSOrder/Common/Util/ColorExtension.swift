//
//  ColorExtension.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    class func hexStringToUIColor (_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    class func gradientColorView(colors:[UIColor], locations:[NSNumber]) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        return gradient
    }
}

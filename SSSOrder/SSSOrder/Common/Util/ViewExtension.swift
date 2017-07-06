//
//  ViewExtension.swift
//  SSSOrder
//
//  Created by Toan Ho on 7/6/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

    func applyGradientLayer(gradientLayer: CAGradientLayer) {
        let gradient: CAGradientLayer = gradientLayer
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

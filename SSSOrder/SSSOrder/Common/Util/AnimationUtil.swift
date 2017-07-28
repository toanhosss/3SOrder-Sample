//
//  AnimationUtil.swift
//  piXMobile
//
//  Created by Thanh Phan on 7/9/16.
//  Copyright © 2017 PI.EXCHANGE PTY LTD. All rights reserved.
//

import Foundation
import UIKit

final class AnimationUtil {

    /// animation rotate view
    static func animationRotateView(view: UIView, to point: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            view.transform = CGAffineTransform(rotationAngle: point)
        }
    }

}

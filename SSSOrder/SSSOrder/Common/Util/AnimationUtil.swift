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

    /// show popup animation
    static func showPopupAnimate(_ view: UIView) {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    /// Close popup animation
    static func removePopupAnimate(_ view: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            view.alpha = 0.0
        }, completion: {(finished: Bool)  in
            if (finished) {
                view.removeFromSuperview()
            }
        })
    }

}

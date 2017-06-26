//
//  PopupUtils.swift
//  piXMobile
//
//  Created by Thanh Phan on 7/9/16.
//  Copyright © 2017 PI.EXCHANGE PTY LTD. All rights reserved.
//

import Foundation
import UIKit

enum PopupType {
    case needHelp
    case termCondition
}

final class PopupUtil {

    static let PopupErrorTitle = "Error"
    static let PopupInfoTitle = "Information"

    @available(iOS 8.0, *)
    static func showAlerPopup(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(confirm)
        return alertController
    }

    @available(iOS 8.0, *)
    static func showInformationPopup(_ title: String, message: String, actionConfirm: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancel)
        let confirm: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            actionConfirm()
        }

        alertController.addAction(confirm)
        return alertController
    }

    static func showInformationPopup(_ title: String, message: String, actionConfirm: @escaping () -> Void, actionCancel: @escaping () -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .default) { (_) in
            actionCancel()
        }
        alertController.addAction(cancel)
        let confirm: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            actionConfirm()
        }

        alertController.addAction(confirm)
        return alertController
    }

    static func showAlertPopup(_ title: String, message: String) -> UIAlertView {
        // Fallback on earlier versions
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        return alertView
    }

    static func showInforPopup(_ title: String, message: String) -> UIAlertView {
        // Fallback on earlier versions
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Cancel")
        alertView.addButton(withTitle: "OK")

        return alertView
    }

    static func showNotificationView(_ title: String, message: String) -> UIView {
        let height = ScreenSize.ScreenHeight*0.15
        let view = UIView(frame: CGRect(x: 0, y: -height, width: ScreenSize.ScreenWidth, height: height))
        view.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)

        return view
    }
}

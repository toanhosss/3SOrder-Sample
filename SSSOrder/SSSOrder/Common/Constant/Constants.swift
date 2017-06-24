//
//  Constants.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

/// Constant screen size
enum ScreenSize {

    static let ScreenWidth = UIScreen.main.bounds.width
    static let ScreenHeight = UIScreen.main.bounds.height
}

/// Constant Image
enum ImageConstant {
    static let AppLogo = UIImage(named: "logo")
    static let IconUser = UIImage(named: "user")
    static let IconPassword = UIImage(named: "lock")

    static let IconRoundFB = UIImage(named: "fb_round_icon")
    static let IconRoundTW = UIImage(named: "twitter_round_icon")
    static let IconRoundGG = UIImage(named: "google_plus_round_icon")

    static let IconCamera = UIImage(named: "camera")
    static let IconPhone = UIImage(named: "mobile")

}

/// Constant Color
enum ColorConstant {
    static let BackgroundColor = UIColor.hexStringToUIColor("#000000", alpha: 0.75)
    static let BackgroundColorAdded = UIColor.hexStringToUIColor("#767676")

    static let ButtonPrimary = UIColor.hexStringToUIColor("#FF3366")
}

/// Constant SegueId
enum SegueNameConstant {
    static let SplashToLogin = "splash_to_login"
    static let LoginToRegister = "login_to_register"
    static let RegisterToLogin = "register_to_login"
    static let LoginToHome = "login_to_home"
    static let RegisterToHome = "register_to_home"
}

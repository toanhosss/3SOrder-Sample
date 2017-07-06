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
    static let IconPhoneNumber = UIImage(named: "phone")
    static let IconHome = UIImage(named: "home")
    static let IconOrderList = UIImage(named: "historyOrder")
    static let IconMenu = UIImage(named: "menu")
    static let IconBooking = UIImage(named: "booking")
    static let IconDelete = UIImage(named: "remove")
    static let IconNote = UIImage(named: "note")
    static let IconMail = UIImage(named: "mail")
    static let IconNear = UIImage(named: "near")
    static let IconAdd = UIImage(named: "add")
    static let IconCart = UIImage(named: "cart")
    static let IconExpand = UIImage(named: "expand")
    static let IconSignout = UIImage(named: "signout")

}

/// Constant Color
enum ColorConstant {
    static let BackgroundColor = UIColor.hexStringToUIColor("#775ADA")
    static let BackgroundColor2 = UIColor.hexStringToUIColor("#775ADA", alpha: 0.56)
    static let BackgroundColorAdded = UIColor.hexStringToUIColor("#28C7FA", alpha: 0.85)
    static let BackgroundPage = UIColor.hexStringToUIColor("#70F5F9")

    static let ButtonPrimary = UIColor.hexStringToUIColor("#FF3366")
    static let NavigationBG = UIColor.hexStringToUIColor("#FF3366")

    static let ShadowColor = UIColor.hexStringToUIColor("#000000", alpha: 0.2)
}

/// Constant SegueId
enum SegueNameConstant {
    static let SplashToLogin = "splash_to_login"
    static let SplashToHome = "splash_to_home"
    static let LoginToRegister = "login_to_register"
    static let RegisterToLogin = "register_to_login"
    static let LoginToHome = "login_to_home"
    static let RegisterToHome = "register_to_home"
    static let HomeToStore = "home_to_store"
    static let StoreToCart = "store_to_cart"
    static let CartToStaff = "cart_to_staff"
    static let StaffToSubmit = "staff_to_submit"
    static let NotificationToNotificationItem = "noti_to_item"
    static let SettingToLogin = "setting_to_login"
}

/// Observe Name Notification
enum ObserveNameConstant {
    static let CartNotificationUpdate = NSNotification.Name.init("UpdateCartNotification")
    static let NewNotificationUpdate = NSNotification.Name.init("UpdateNewNotification")
}

/// URL Constant
enum URLConstant {
    static var baseURL = "http://3sorder.success-ss.com.vn:8889"
}

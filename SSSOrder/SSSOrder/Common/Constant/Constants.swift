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
    static let IconRemove = UIImage(named: "delete")
    static let IconCart = UIImage(named: "cart")
    static let IconExpand = UIImage(named: "expand")
    static let IconSignout = UIImage(named: "signout")
    static let IconSwitchAPI = UIImage(named: "switch")
    static let IconShare = UIImage(named: "share")
    static let IconStarEmpty = UIImage(named: "star_empty")
    static let IconStarFull = UIImage(named: "star_full")
    static let IconClose = UIImage(named: "close")
    static let IconBack = UIImage(named: "back")
    static let IconLocation = UIImage(named: "location")
    static let IconChecked = UIImage(named: "checked")
    static let IconDown = UIImage(named: "down")
    static let IconNoImage = UIImage(named: "no_image")
    static let IconScanQR = UIImage(named: "scan_qr")

}

/// Constant Color
enum ColorConstant {
    static let BackgroundColor = UIColor.hexStringToUIColor("#00bcd4")
    static let BackgroundColor2 = UIColor.hexStringToUIColor("#775ADA", alpha: 0.56)
    static let BackgroundColorAdded = UIColor.hexStringToUIColor("#28C7FA", alpha: 0.85)
    static let BackgroundPage = UIColor.hexStringToUIColor("#70F5F9")

    static let ButtonPrimary = UIColor.hexStringToUIColor("#00bcd4")
    static let ButtonSecond = UIColor.hexStringToUIColor("#3B5998")
    static let NavigationBG = UIColor.hexStringToUIColor("#00bcd4")

    static let NotificationNewColor = UIColor.hexStringToUIColor("#E4F1FE")

    static let ShadowColor = UIColor.hexStringToUIColor("#D9E2E9", alpha: 0.5)
}

enum FontConstant {
    static let TitlePageFont = UIFont(name: "HelveticaNeue-Bold", size: 20)
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
    static let SettingToScanQR = "setting_to_scanqrcode"
}

/// Observe Name Notification
enum ObserveNameConstant {
    static let CartNotificationUpdate = NSNotification.Name.init("UpdateCartNotification")
    static let NewNotificationUpdate = NSNotification.Name.init("UpdateNewNotification")
}

/// URL Constant
enum URLConstant {
    static var baseURL = "http://3sorder.success-ss.com.vn:8889"
    static var qrUrl = ""
}

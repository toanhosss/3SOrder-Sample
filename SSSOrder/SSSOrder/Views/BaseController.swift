//
//  ViewController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import ReachabilitySwift

class BaseController: UIViewController {

    var overlayView: UIView!
    var overlayColor: UIColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.5)
    var navigationBarView: UIView?
    var titleLabel: UILabel?

    let tapInputKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    private var _backTitle = ""
    var backTitle: String {
        get {
            return _backTitle
        }

        set {
            _backTitle = newValue
            setBacktitle()
        }
    }

    private var _titleText: String = ""
    var titlePage: String {
        get {
            return _titleText
        }

        set {
            _titleText = newValue
            setTitlePage()
        }
    }

    private var _titleColor = UIColor.white
    var titleColor: UIColor {

        get {
            return _titleColor
        }

        set {
            _titleColor = newValue
            setTitlePage()
        }
    }

    private var _navigationBG = ColorConstant.NavigationBG
    var navigationBG: UIColor {
        get {
            return _navigationBG
        }

        set {
            _navigationBG = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        for name in UIFont.familyNames {
//            print(name)
//            if let nameString = name as? String
//            {
//                print(UIFont.fontNames(forFamilyName: nameString))
//            }
//        }

        setLayoutPage()

        setEventAndDelegate()
    }

    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Set Navigation information bar
    func setNavigationBar() {

        if navigationBarView != nil {
            navigationBarView!.removeFromSuperview()
            navigationBarView = nil
        }

        navigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth,
                                                 height: ScreenSize.ScreenHeight*0.1))
        self.view.addSubview(navigationBarView!)

        setNavigationBackground()

        setTitlePage()
    }

    /// Set Back Title
    func setBacktitle() {
        guard self.navigationBarView != nil else {
            return
        }

        let backLabel = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.025, y: ScreenSize.ScreenHeight*0.04, width: ScreenSize.ScreenWidth*0.075, height: ScreenSize.ScreenWidth*0.075))
        backLabel.image = ImageConstant.IconBack
        backLabel.contentMode = .scaleAspectFit

        let tapBackButton = UITapGestureRecognizer(target: self, action: #selector(backButtonTouched(sender:)))
        backLabel.isUserInteractionEnabled = true
        backLabel.addGestureRecognizer(tapBackButton)
        self.navigationBarView!.addSubview(backLabel)
    }

    /// Set title page
    func setTitlePage() {

        guard self.navigationBarView != nil else {
            return
        }

        if titleLabel == nil {
            titleLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.25, y: ScreenSize.ScreenHeight*0.025, width: ScreenSize.ScreenWidth*0.5, height: ScreenSize.ScreenHeight*0.075))
        }
        titleLabel!.textAlignment = .center
        titleLabel!.font = FontConstant.TitlePageFont
        titleLabel!.text = self.titlePage
        titleLabel!.textColor = titleColor
        self.navigationBarView!.addSubview(titleLabel!)
    }

    /// Get user logged
    func getUserLoggedInfo() -> User? {
        let user = UserDefaultUtils.getUser()

        if user != nil {
            return user
        }

        return nil
    }

    /// Set background navigation
    func setNavigationBackground() {
        guard self.navigationBarView != nil else {
            return
        }

        self.navigationBarView!.backgroundColor = navigationBG
        self.tabBarController!.tabBar.barTintColor = .white
    }

    /// Set tabbar Icon
    func setTabbarIcon(icons: [UIImage], name: [String]) {

        for i in 0..<icons.count {

            let customTabBarItem: UITabBarItem = UITabBarItem(title: name[i], image: icons[i].withRenderingMode(.alwaysOriginal),
                                                              selectedImage: icons[i].withRenderingMode(.alwaysTemplate))
            customTabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.hexStringToUIColor("#807D7D")], for: .normal)
            customTabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: ColorConstant.BackgroundColor], for: .highlighted)
            self.tabBarController!.viewControllers![i].tabBarItem = customTabBarItem
            self.tabBarController!.viewControllers![i].tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
            self.tabBarController?.tabBar.tintColor = ColorConstant.BackgroundColor
        }

    }

    /// Combo Set Layout for current page:
    /// - Set background
    /// - Set view element
    func setLayoutPage() {
        // set background
        customizeBackground()

        setNavigationBar()
    }

    /// Customize Background color
    func customizeBackground() {
//        let viewLayer1 = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight))
//        let gradienColor = UIColor.gradientColorView(colors: [ColorConstant.BackgroundColor, ColorConstant.BackgroundColor2], locations: [0.0, 0.55])
//        self.view.backgroundColor = ColorConstant.BackgroundColorAdded
//        self.view.applyGradientLayer(gradientLayer: gradienColor)
//        self.view.addSubview(viewLayer1)
        self.view.backgroundColor = UIColor.hexStringToUIColor("#ecf0f1")
    }

    /// Set Delegate and NotificationCenter
    func setEventAndDelegate() {

        // Set notification for show/hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    /// Get NetWork status
    func getNetWorkStatus() -> Bool {
        return appDelegate!.netWorkStatus
    }

    /// Show Overlay loading view
    func showOverlayLoading(_ indicatorViewStyle: UIActivityIndicatorViewStyle = .whiteLarge) {
        if overlayView != nil {
            return
        }
        overlayView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight))
        overlayView.backgroundColor = overlayColor
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width*0.1, height: overlayView.bounds.width*0.1)
        activityIndicator.activityIndicatorViewStyle = indicatorViewStyle
        activityIndicator.color = UIColor.hexStringToUIColor("#000000", alpha: 0.5)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(activityIndicator)
        self.view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }

    /*
     * Remove Overlay loading view
     */
    func removeOverlayLoading() {
        if overlayView == nil {
            return
        }

        self.overlayView.removeFromSuperview()
        self.overlayView = nil
    }

    func showInfoMessage(_ message: String) {
        present(PopupUtil.showAlerPopup(PopupUtil.PopupInfoTitle, message: message), animated: true, completion: nil)
    }

    func showErrorMessage(_ error: String) {
        present(PopupUtil.showAlerPopup(PopupUtil.PopupErrorTitle, message: error), animated: true, completion: nil)
    }

    // MARK: General Handler Button
    func backButtonTouched(sender: UITapGestureRecognizer) {
        print("Navigation back")
        guard self.navigationController != nil else {
            return
        }

        self.navigationController!.popViewController(animated: true)
    }

}

extension BaseController: UITextFieldDelegate {

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
     Makes the cursor to jump to the next textfield if the "Next" button
     is pressed from the keyboard.
     */
    func jumpToNextTextField(_ textField: UITextField, withTag tag: Int) {
        // Gets the next responder from the view. Here we use self.view because we are searching for controls with
        // a specific tag, which are not subviews of a specific views, because each textfield belongs to the
        // content view of a static table cell.
        //
        // In other cases may be more convenient to use textField.superView, if all textField belong to the same view.
        let nextResponder = self.view.viewWithTag(tag)
        if (nextResponder?.isKind(of: UITextField.self)) != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

    }

    /*
     * Delegate set action for each text field
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            let nextTag = textField.tag + 1
            jumpToNextTextField(textField, withTag: nextTag)
        case .done:
            NotificationCenter.default.post(name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        default:
            textField.resignFirstResponder()
        }
        return false
    }

    // Set move up frame when keyboard show
    func keyboardWillShow(_ notification: Notification) {
        // Set event to hide keyboard
        view.addGestureRecognizer(tapInputKeyboard)
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardSize.height
            } else {

            }
        }

    }

    // Set move up frame when keyboard hide
    func keyboardWillHide(_ notification: Notification) {
        view.removeGestureRecognizer(tapInputKeyboard)
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil && view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

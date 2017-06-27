//
//  ViewController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit
import RxSwift

class BaseController: UIViewController {

    var overlayView: UIView!
    var navigationBarView: UIView?
    var titleLabel: UILabel?

    let tapInputKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

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

    // MARK: Rx
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let backLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.025, y: ScreenSize.ScreenHeight*0.025, width: ScreenSize.ScreenWidth*0.25, height: ScreenSize.ScreenHeight*0.075))
        backLabel.text = "< " + backTitle
        backLabel.textColor = titleColor
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
        titleLabel!.text = self.titlePage
        titleLabel!.textColor = titleColor
        self.navigationBarView!.addSubview(titleLabel!)
    }

    /// Set background navigation
    func setNavigationBackground() {
        guard self.navigationBarView != nil else {
            return
        }

        self.navigationBarView!.backgroundColor = navigationBG
        self.tabBarController!.tabBar.barTintColor = navigationBG
    }

    /// Set tabbar Icon
    func setTabbarIcon(icons: [UIImage]) {

        for i in 0..<icons.count {

            let customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: icons[i].withRenderingMode(.alwaysTemplate),
                                                              selectedImage: icons[i].withRenderingMode(.alwaysOriginal))

            self.tabBarController!.viewControllers![i].tabBarItem = customTabBarItem
            self.tabBarController!.viewControllers![i].tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            self.tabBarController?.tabBar.tintColor = .gray
        }

    }

    /// Combo Set Layout for current page:
    /// - Set background
    /// - Set view element
    func setLayoutPage() {
        // set background
        self.view.backgroundColor = ColorConstant.BackgroundPage

        setNavigationBar()
    }

    /// Set Delegate and NotificationCenter
    func setEventAndDelegate() {

        // Set notification for show/hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    /// Show Overlay loading view
    func showOverlayLoading(_ indicatorViewStyle: UIActivityIndicatorViewStyle = .whiteLarge) {
        if overlayView != nil {
            return
        }
        overlayView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.ScreenWidth, height: ScreenSize.ScreenHeight))
        overlayView.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: overlayView.bounds.width*0.1, height: overlayView.bounds.width*0.1)
        activityIndicator.activityIndicatorViewStyle = indicatorViewStyle
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

//
//  ViewController.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class BaseController: UIViewController {

    var overlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

    /// Combo Set Layout for current page:
    /// - Set background
    /// - Set view element
    func setLayoutPage() {

    }

    /// Set Delegate and NotificationCenter
    func setEventAndDelegate() {
        // Set event to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

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
        overlayView.backgroundColor = .white
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

        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil && view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

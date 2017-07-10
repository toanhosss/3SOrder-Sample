//
//  RegisterViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class RegisterViewController: BaseController {

    var nameInput: HoshiTextField!
    var mobileNumberInput: HoshiTextField!
    var passwordInput: HoshiTextField!
    var confirmPassInput: HoshiTextField!
    var avatarView: UIView!

    var registerController = RegisterController.SharedInstance

    override func setLayoutPage() {
        customizeBackground()

        // init title
        let title = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.06221,
                                          width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.06))
        title.text = NSLocalizedString("createAccount", comment: "")
        title.textAlignment = .center
        title.textColor = ColorConstant.BackgroundColor
        title.font = UIFont.boldSystemFont(ofSize: 20)

        self.view.addSubview(title)

        initFormRegister()
    }

    func initFormRegister() {

        initInputForm()

        initBackLabel()
    }

    func initInputForm() {
        let left = ScreenSize.ScreenWidth*0.075
        let width = ScreenSize.ScreenWidth*0.85
        let height = ScreenSize.ScreenHeight*0.0749625

        nameInput = HoshiTextField(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.3027586, width: width, height: height))

        nameInput.borderActiveColor = ColorConstant.BackgroundColor
        nameInput.tintColor = ColorConstant.BackgroundColor
        nameInput.borderInactiveColor = .gray

        nameInput.placeholder = NSLocalizedString("name", comment: "user label")
        nameInput.placeholderFontScale = 0.9
        nameInput.placeholderColor = .gray

        mobileNumberInput = HoshiTextField(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.412518, width: width, height: height))

        mobileNumberInput.borderActiveColor = ColorConstant.BackgroundColor
        mobileNumberInput.borderInactiveColor = .gray
        mobileNumberInput.tintColor = ColorConstant.BackgroundColor

        mobileNumberInput.placeholder = NSLocalizedString("phone", comment: "user label")
        mobileNumberInput.placeholderFontScale = 0.9
        mobileNumberInput.placeholderColor = .gray

        passwordInput = HoshiTextField(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.50997,
                                                           width: width, height: height))

        passwordInput.borderActiveColor = ColorConstant.BackgroundColor
        passwordInput.borderInactiveColor = .gray
        passwordInput.isSecureTextEntry = true
        passwordInput.tintColor = ColorConstant.BackgroundColor

        passwordInput.placeholder = NSLocalizedString("pass", comment: "user label")
        passwordInput.placeholderFontScale = 0.9
        passwordInput.placeholderColor = .gray

        confirmPassInput = HoshiTextField(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.6074212, width: width, height: height))

        confirmPassInput.borderActiveColor = ColorConstant.BackgroundColor
        confirmPassInput.borderInactiveColor = .gray
        confirmPassInput.isSecureTextEntry = true
        confirmPassInput.tintColor = ColorConstant.BackgroundColor

        confirmPassInput.placeholder = NSLocalizedString("confirmPass", comment: "user label")
        confirmPassInput.placeholderFontScale = 0.9
        confirmPassInput.placeholderColor = .gray

        // set Register Button
        let registerButton = UIButton(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.724872, width: width, height: height))
        registerButton.backgroundColor = ColorConstant.ButtonPrimary
        registerButton.setTitle(NSLocalizedString("register", comment: "label button"), for: .normal)
        registerButton.layer.cornerRadius = registerButton.frame.height*0.1
        registerButton.addTarget(self, action: #selector(registerButtonTouched(sender:)), for: .touchUpInside)

        self.view.addSubview(registerButton)
        self.view.addSubview(nameInput)
        self.view.addSubview(mobileNumberInput)
        self.view.addSubview(passwordInput)
        self.view.addSubview(confirmPassInput)
    }

    func initBackLabel() {
        let backLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.9,
                                              width: ScreenSize.ScreenWidth*0.872,
                                              height: ScreenSize.ScreenHeight*0.03748))
        backLabel.text = NSLocalizedString("labelBack", comment: "")
        backLabel.textColor = ColorConstant.BackgroundColor
        backLabel.textAlignment = .center
        let tapBackRecognizer = UITapGestureRecognizer(target: self, action: #selector(backToSignInTouched(sender:)))
        backLabel.isUserInteractionEnabled = true
        backLabel.addGestureRecognizer(tapBackRecognizer)

        self.view.addSubview(backLabel)
    }

    // MARK: Event Handler Touches
    @objc func registerButtonTouched(sender: UIButton) {
        print("REGISTER")
        self.showOverlayLoading()
        DispatchQueue.main.async {
            let user = User(userId: -1, name: self.nameInput.text!, phone: self.mobileNumberInput.text!)
            self.registerController.register(user: user, password: self.passwordInput.text, confirmPassword: self.confirmPassInput.text, callback: { (user, error) in
                self.removeOverlayLoading()
                if user != nil {
                    self.performSegue(withIdentifier: SegueNameConstant.RegisterToHome, sender: nil)
                } else {
                    self.showErrorMessage(error!)
                }
            })
        }
    }

    @objc func backToSignInTouched(sender: UITapGestureRecognizer) {
        print("FORGOT PASSWORD")
        self.performSegue(withIdentifier: SegueNameConstant.RegisterToLogin, sender: nil)
    }

    override func keyboardWillShow(_ notification: Notification) {
        let tapInputKeyboard2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapInputKeyboard2.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapInputKeyboard2)

        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 && self.confirmPassInput.isFirstResponder {
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                self.view.frame.origin.y = 0
            }
        }
    }

    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        self.nameInput.endEditing(true)
        self.mobileNumberInput.endEditing(true)
        self.passwordInput.endEditing(true)
        self.confirmPassInput.endEditing(true)
    }
}

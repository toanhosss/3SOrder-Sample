//
//  LoginViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class LoginViewController: BaseController {

    var userInput: HoshiTextField!
    var passwordInput: HoshiTextField!

    let loginController = LoginController.SharedInstance

    override func setLayoutPage() {
        // set background
        customizeBackground()

        // set logo
        let logo = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.318666, y: ScreenSize.ScreenHeight*0.071964, width: ScreenSize.ScreenWidth*0.362667, height: ScreenSize.ScreenHeight*0.209895))
        logo.image = ImageConstant.AppLogo?.withRenderingMode(.alwaysTemplate)
        logo.tintColor = ColorConstant.BackgroundColor
        self.view.addSubview(logo)

        // set view element
        setLoginView()
    }

    func setLoginView() {

        // set Login Username Input
        addLoginElement()

        // set create account label
        initCreateAndForGotLabel()

//        // draw line view
//        let lineLeft = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
//                                            y: ScreenSize.ScreenHeight*0.757871,
//                                            width: ScreenSize.ScreenWidth*0.33733,
//                                            height: 0.5))
//        lineLeft.backgroundColor = .white
//
//        let orLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.48,
//                                            y: ScreenSize.ScreenHeight*0.746071,
//                                            width: ScreenSize.ScreenWidth*0.08,
//                                            height: ScreenSize.ScreenHeight*0.03748))
//        orLabel.text = NSLocalizedString("or", comment: "")
//        orLabel.textColor = .white
//        orLabel.adjustsFontSizeToFitWidth = true
//
//        let lineRight = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.597333, y: ScreenSize.ScreenHeight*0.757871,
//                                            width: ScreenSize.ScreenWidth*0.33733,
//                                            height: 0.5))
//        lineRight.backgroundColor = .white
//
        // set other login
        addOtherLogin()
//
//        self.view.addSubview(lineLeft)
//        self.view.addSubview(orLabel)
//        self.view.addSubview(lineRight)
    }

    func addLoginElement() {
        let height = ScreenSize.ScreenHeight*0.089625
        let width = ScreenSize.ScreenWidth*0.85
        let left = ScreenSize.ScreenWidth*0.075

        userInput = HoshiTextField(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.3527586, width: width, height: height))
        userInput.borderActiveColor = ColorConstant.BackgroundColor
        userInput.keyboardType = .numberPad
        userInput.tintColor = ColorConstant.BackgroundColor
        userInput.borderInactiveColor = .gray

        userInput.placeholder = NSLocalizedString("phone", comment: "user label")
        userInput.placeholderFontScale = 0.9
        userInput.placeholderColor = .gray

        // set Login Password Input
        passwordInput = HoshiTextField(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.45020989, width: width, height: height))

        passwordInput.borderActiveColor = ColorConstant.BackgroundColor
        passwordInput.returnKeyType = .done
        passwordInput.delegate = self
        passwordInput.borderInactiveColor = .gray
        passwordInput.isSecureTextEntry = true
        passwordInput.tintColor = ColorConstant.BackgroundColor

        passwordInput.placeholder = NSLocalizedString("pass", comment: "user label")
        passwordInput.placeholderFontScale = 0.9
        passwordInput.placeholderColor = .gray

        // set Login Button
        let loginButton = UIButton(frame: CGRect(x: left, y: ScreenSize.ScreenHeight*0.6076611, width: width, height: height))
        loginButton.backgroundColor = ColorConstant.ButtonPrimary
        loginButton.setTitle(NSLocalizedString("signin", comment: "label button"), for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.height*0.1

        loginButton.addTarget(self, action: #selector(signInButtonTouched(sender:)), for: .touchUpInside)

        self.view.addSubview(loginButton)

        self.view.addSubview(userInput)
        self.view.addSubview(passwordInput)
    }

    func initCreateAndForGotLabel() {

        let topLabel = ScreenSize.ScreenHeight*0.91754122
        let height = ScreenSize.ScreenHeight*0.026985

        // set forgot password label
        let forgotPasswordLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.075, y: topLabel,
                                                        width: ScreenSize.ScreenWidth*0.425, height: height))
        forgotPasswordLabel.textColor = ColorConstant.ButtonPrimary
        forgotPasswordLabel.textAlignment = .left
        forgotPasswordLabel.text = NSLocalizedString("forgotPass", comment: "")
        forgotPasswordLabel.adjustsFontSizeToFitWidth = true
        let tapForgotRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTouched(sender:)))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(tapForgotRecognizer)

        let createAccountLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.5,
                                                       y: topLabel,
                                                       width: ScreenSize.ScreenWidth*0.425,
                                                       height: height))
        createAccountLabel.textColor = ColorConstant.ButtonPrimary
        createAccountLabel.textAlignment = .right
        createAccountLabel.text = NSLocalizedString("createAccount", comment: "")
        createAccountLabel.adjustsFontSizeToFitWidth = true
        let tapCreateAccountRecognizer = UITapGestureRecognizer(target: self, action: #selector(createAccountTouched(sender:)))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(tapCreateAccountRecognizer)

        self.view.addSubview(createAccountLabel)
        self.view.addSubview(forgotPasswordLabel)

    }

    func addOtherLogin() {

//        let text2 = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
//                                          y: ScreenSize.ScreenHeight*0.823088,
//                                          width: ScreenSize.ScreenWidth*0.321333,
//                                          height: ScreenSize.ScreenHeight*0.03748))
//        text2.text = NSLocalizedString("text2", comment: "")
//        text2.textColor = .white
//        text2.adjustsFontSizeToFitWidth = true

        let buttonHeight = ScreenSize.ScreenHeight*0.089625
        let buttonWidth = ScreenSize.ScreenWidth*0.4
        let top = ScreenSize.ScreenHeight*0.72511244

        let fbButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.075, y: top, width: buttonWidth, height: buttonHeight))
        fbButton.layer.cornerRadius = buttonHeight*0.1
        fbButton.backgroundColor = UIColor.hexStringToUIColor("#3B5998")
        fbButton.setTitle("Facebook", for: .normal)
        fbButton.addTarget(self, action: #selector(signInFBButtonTouched(sender:)), for: .touchUpInside)
//        let twButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.61067, y: buttonTop, width: buttonSize, height: buttonSize))
//        twButton.layer.cornerRadius = buttonSize*0.5
//        twButton.setImage(ImageConstant.IconRoundTW, for: .normal)
//        twButton.addTarget(self, action: #selector(signInTWButtonTouched(sender:)), for: .touchUpInside)
        let ggButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.525, y: top, width: buttonWidth, height: buttonHeight))
        ggButton.layer.cornerRadius = buttonHeight*0.1
        ggButton.backgroundColor = UIColor.hexStringToUIColor("#DB4437")
        ggButton.setTitle("Google+", for: .normal)
        ggButton.addTarget(self, action: #selector(signInGGButtonTouched(sender:)), for: .touchUpInside)

//        self.view.addSubview(text2)
        self.view.addSubview(fbButton)
//        self.view.addSubview(twButton)
        self.view.addSubview(ggButton)
    }

    override func setEventAndDelegate() {
        // Set event to hide keyboard
        super.setEventAndDelegate()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: Event Handler Touches
    @objc func signInButtonTouched(sender: UIButton) {
        print("SIGN IN")
        self.showOverlayLoading()
        DispatchQueue.main.async {
            self.loginController.login(phone: self.userInput.text, password: self.passwordInput.text, callback: { (user, error) in

                self.removeOverlayLoading()
                if user != nil {
                    self.performSegue(withIdentifier: SegueNameConstant.LoginToHome, sender: nil)
                } else {
                    self.showErrorMessage(error!)
                }

            })
        }

    }

    @objc func signInFBButtonTouched(sender: UIButton) {
        print("SIGN IN WITH FB")
    }
    @objc func signInTWButtonTouched(sender: UIButton) {
        print("SIGN IN WITH TWITTER")
    }
    @objc func signInGGButtonTouched(sender: UIButton) {
        print("SIGN IN WITH GOOGLE+")
    }

    @objc func createAccountTouched(sender: UITapGestureRecognizer) {
        print("REGISTER")
        self.showOverlayLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
            self.removeOverlayLoading()
            self.performSegue(withIdentifier: SegueNameConstant.LoginToRegister, sender: nil)
        }
    }

    @objc func forgotPasswordTouched(sender: UITapGestureRecognizer) {
        print("FORGOT PASSWORD")
    }

    override func keyboardWillShow(_ notification: Notification) {
        let tapInputKeyboard2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapInputKeyboard2.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapInputKeyboard2)

    }
}

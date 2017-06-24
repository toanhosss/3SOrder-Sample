//
//  LoginViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class LoginViewController: BaseController {

    var userInput: CustomInputField!
    var passwordInput: CustomInputField!

    override func setLayoutPage() {
        // set background
        self.view.backgroundColor = ColorConstant.BackgroundColor

        // set logo
        let logo = UIImageView(frame: CGRect(x: ScreenSize.ScreenWidth*0.318666, y: ScreenSize.ScreenHeight*0.071964, width: ScreenSize.ScreenWidth*0.362667, height: ScreenSize.ScreenHeight*0.209895))
        logo.image = ImageConstant.AppLogo
        self.view.addSubview(logo)

        // set view element
        setLoginView()
    }

    func setLoginView() {

        // set Login Username Input
        addLoginElement()

        // set create account label
        initCreateAndForGotLabel()

        // draw line view
        let lineLeft = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                            y: ScreenSize.ScreenHeight*0.757871,
                                            width: ScreenSize.ScreenWidth*0.33733,
                                            height: 0.5))
        lineLeft.backgroundColor = .white

        let orLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.48,
                                            y: ScreenSize.ScreenHeight*0.746071,
                                            width: ScreenSize.ScreenWidth*0.08,
                                            height: ScreenSize.ScreenHeight*0.03748))
        orLabel.text = NSLocalizedString("or", comment: "")
        orLabel.textColor = .white
        orLabel.adjustsFontSizeToFitWidth = true

        let lineRight = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.597333, y: ScreenSize.ScreenHeight*0.757871,
                                            width: ScreenSize.ScreenWidth*0.33733,
                                            height: 0.5))
        lineRight.backgroundColor = .white

        // set other login
        addOtherLogin()

        self.view.addSubview(lineLeft)
        self.view.addSubview(orLabel)
        self.view.addSubview(lineRight)
    }

    func addLoginElement() {
        userInput = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                   y: ScreenSize.ScreenHeight*0.3650675,
                                                   width: ScreenSize.ScreenWidth*0.872,
                                                   height: ScreenSize.ScreenHeight*0.084707),
                                     icon: ImageConstant.IconUser!)

        userInput.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("phone", comment: "user label"),
                                                                            attributes: [NSForegroundColorAttributeName: UIColor.white])
        userInput.inputTextField.textColor = .white
        userInput.inputTextField.tag = 1

        userInput.layer.cornerRadius = userInput.frame.height*0.5
        userInput.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)

        userInput.inputTextField.delegate = self

        // set Login Password Input
        passwordInput = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                       y: ScreenSize.ScreenHeight*0.462518,
                                                       width: ScreenSize.ScreenWidth*0.872,
                                                       height: ScreenSize.ScreenHeight*0.084707),
                                         icon: ImageConstant.IconPassword!)

        passwordInput.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("pass", comment: "user label"),
                                                                                attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordInput.inputTextField.textColor = .white
        passwordInput.inputTextField.tag = 2
        passwordInput.isSecureText = true

        passwordInput.layer.cornerRadius = passwordInput.frame.height*0.5
        passwordInput.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)

        passwordInput.inputTextField.delegate = self

        // set Login Button
        let loginButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                 y: ScreenSize.ScreenHeight*0.55997,
                                                 width: ScreenSize.ScreenWidth*0.872,
                                                 height: ScreenSize.ScreenHeight*0.084707))
        loginButton.backgroundColor = ColorConstant.ButtonPrimary
        loginButton.setTitle(NSLocalizedString("signin", comment: "label button"), for: .normal)
        loginButton.layer.cornerRadius = loginButton.frame.height*0.5

        loginButton.addTarget(self, action: #selector(signInButtonTouched(sender:)), for: .touchUpInside)

        self.view.addSubview(loginButton)

        self.view.addSubview(userInput)
        self.view.addSubview(passwordInput)
    }
    func initCreateAndForGotLabel() {
        let createAccountLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                       y: ScreenSize.ScreenHeight*0.68215892,
                                                       width: ScreenSize.ScreenWidth*0.30533,
                                                       height: ScreenSize.ScreenHeight*0.03748))
        createAccountLabel.textColor = .white
        createAccountLabel.textAlignment = .left
        createAccountLabel.text = NSLocalizedString("createAccount", comment: "")
        createAccountLabel.adjustsFontSizeToFitWidth = true
        let tapCreateAccountRecognizer = UITapGestureRecognizer(target: self, action: #selector(createAccountTouched(sender:)))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(tapCreateAccountRecognizer)

        // set forgot password label
        let forgotPasswordLabel = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.60267,
                                                        y: ScreenSize.ScreenHeight*0.68215892,
                                                        width: ScreenSize.ScreenWidth*0.328,
                                                        height: ScreenSize.ScreenHeight*0.03748))
        forgotPasswordLabel.textColor = .white
        forgotPasswordLabel.textAlignment = .left
        forgotPasswordLabel.text = NSLocalizedString("forgotPass", comment: "")
        forgotPasswordLabel.adjustsFontSizeToFitWidth = true
        let tapForgotRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTouched(sender:)))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(tapForgotRecognizer)

        self.view.addSubview(createAccountLabel)
        self.view.addSubview(forgotPasswordLabel)

    }

    func addOtherLogin() {

        let text2 = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                          y: ScreenSize.ScreenHeight*0.823088,
                                          width: ScreenSize.ScreenWidth*0.321333,
                                          height: ScreenSize.ScreenHeight*0.03748))
        text2.text = NSLocalizedString("text2", comment: "")
        text2.textColor = .white
        text2.adjustsFontSizeToFitWidth = true

        let buttonTop = ScreenSize.ScreenHeight*0.805847
        let buttonSize = ScreenSize.ScreenWidth*0.124

        let fbButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.43733, y: buttonTop, width: buttonSize, height: buttonSize))
        fbButton.layer.cornerRadius = buttonSize*0.5
        fbButton.setImage(ImageConstant.IconRoundFB, for: .normal)
        fbButton.addTarget(self, action: #selector(signInFBButtonTouched(sender:)), for: .touchUpInside)
        let twButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.61067, y: buttonTop, width: buttonSize, height: buttonSize))
        twButton.layer.cornerRadius = buttonSize*0.5
        twButton.setImage(ImageConstant.IconRoundTW, for: .normal)
        twButton.addTarget(self, action: #selector(signInTWButtonTouched(sender:)), for: .touchUpInside)
        let ggButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.784, y: buttonTop, width: buttonSize, height: buttonSize))
        ggButton.layer.cornerRadius = buttonSize*0.5
        ggButton.setImage(ImageConstant.IconRoundGG, for: .normal)
        ggButton.addTarget(self, action: #selector(signInGGButtonTouched(sender:)), for: .touchUpInside)

        self.view.addSubview(text2)
        self.view.addSubview(fbButton)
        self.view.addSubview(twButton)
        self.view.addSubview(ggButton)
    }

    override func setEventAndDelegate() {
        // Set event to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: Event Handler Touches
    @objc func signInButtonTouched(sender: UIButton) {
        print("SIGN IN")
        self.showOverlayLoading()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.removeOverlayLoading()
            self.performSegue(withIdentifier: SegueNameConstant.LoginToHome, sender: nil)
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

}

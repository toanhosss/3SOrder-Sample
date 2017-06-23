//
//  RegisterViewController.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/24/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class RegisterViewController: BaseController {

    var nameInput: CustomInputField!
    var mobileNumberInput: CustomInputField!
    var passwordInput: CustomInputField!
    var confirmPassInput: CustomInputField!
    var avatarView: UIView!

    override func setLayoutPage() {
        // set background
        self.view.backgroundColor = ColorConstant.BackgroundColor

        // init title
        let title = UILabel(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.06221,
                                          width: ScreenSize.ScreenWidth*0.872, height: ScreenSize.ScreenHeight*0.06))
        title.text = NSLocalizedString("createAccount", comment: "")
        title.textAlignment = .center
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)

        self.view.addSubview(title)

        initFormRegister()
    }

    func initFormRegister() {
        // init aded avatar button
        let avatarSize = ScreenSize.ScreenWidth*0.310667
        avatarView = UIView(frame: CGRect(x: ScreenSize.ScreenWidth*0.344, y: ScreenSize.ScreenHeight*0.13943, width: avatarSize, height: avatarSize))

        let imageIcon = UIImageView(frame: CGRect(x: avatarSize*0.295965, y: avatarSize*0.34335, width: avatarSize*0.40807, height: avatarSize*0.3133))
        imageIcon.tag = 100
        imageIcon.image = ImageConstant.IconCamera
        imageIcon.contentMode = .scaleAspectFit

        let buttonImage = UIButton(frame: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize))
        buttonImage.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        buttonImage.layer.cornerRadius = avatarSize*0.5

        avatarView.addSubview(imageIcon)
        avatarView.addSubview(buttonImage)
        self.view.addSubview(avatarView)

        initInputForm()

        initBackLabel()
    }

    func initInputForm() {

        let placeHolderTextAttribute = [NSForegroundColorAttributeName: UIColor.white]
        nameInput = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064, y: ScreenSize.ScreenHeight*0.3650675,
                                                   width: ScreenSize.ScreenWidth*0.872,
                                                   height: ScreenSize.ScreenHeight*0.084707),
                                     icon: ImageConstant.IconUser!)

        nameInput.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("name", comment: ""),
                                                                            attributes: placeHolderTextAttribute)
        nameInput.inputTextField.textColor = .white
        nameInput.inputTextField.tag = 1
        nameInput.layer.cornerRadius = nameInput.frame.height*0.5
        nameInput.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        nameInput.inputTextField.delegate = self

        mobileNumberInput = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                       y: ScreenSize.ScreenHeight*0.462518,
                                                       width: ScreenSize.ScreenWidth*0.872,
                                                       height: ScreenSize.ScreenHeight*0.084707),
                                         icon: ImageConstant.IconPassword!)

        mobileNumberInput.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("phone", comment: "user label"),
                                                                                attributes: placeHolderTextAttribute)
        mobileNumberInput.inputTextField.textColor = .white
        mobileNumberInput.inputTextField.tag = 2
        mobileNumberInput.isSecureText = true
        mobileNumberInput.layer.cornerRadius = mobileNumberInput.frame.height*0.5
        mobileNumberInput.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        mobileNumberInput.inputTextField.delegate = self

        passwordInput = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                           y: ScreenSize.ScreenHeight*0.55997,
                                                           width: ScreenSize.ScreenWidth*0.872,
                                                           height: ScreenSize.ScreenHeight*0.084707),
                                             icon: ImageConstant.IconPassword!)

        passwordInput.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("pass", comment: "user label"),
                                                                                    attributes: placeHolderTextAttribute)
        passwordInput.inputTextField.textColor = .white
        passwordInput.inputTextField.tag = 2
        passwordInput.isSecureText = true
        passwordInput.layer.cornerRadius = passwordInput.frame.height*0.5
        passwordInput.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        passwordInput.inputTextField.delegate = self

        confirmPassInput = CustomInputField(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                          y: ScreenSize.ScreenHeight*0.6574212,
                                                       width: ScreenSize.ScreenWidth*0.872,
                                                       height: ScreenSize.ScreenHeight*0.084707),
                                         icon: ImageConstant.IconPassword!)

        confirmPassInput.inputTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("confirmPass", comment: "user label"),
                                                                                attributes: placeHolderTextAttribute)
        confirmPassInput.inputTextField.textColor = .white
        confirmPassInput.inputTextField.tag = 2
        confirmPassInput.isSecureText = true
        confirmPassInput.layer.cornerRadius = confirmPassInput.frame.height*0.5
        confirmPassInput.backgroundColor = UIColor.hexStringToUIColor("#FFFFFF", alpha: 0.1)
        confirmPassInput.inputTextField.delegate = self

        // set Register Button
        let registerButton = UIButton(frame: CGRect(x: ScreenSize.ScreenWidth*0.064,
                                                 y: ScreenSize.ScreenHeight*0.754872,
                                                 width: ScreenSize.ScreenWidth*0.872,
                                                 height: ScreenSize.ScreenHeight*0.084707))
        registerButton.backgroundColor = ColorConstant.ButtonPrimary
        registerButton.setTitle(NSLocalizedString("register", comment: "label button"), for: .normal)
        registerButton.layer.cornerRadius = registerButton.frame.height*0.5

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
        backLabel.textColor = .white
        backLabel.textAlignment = .center
        let tapBackRecognizer = UITapGestureRecognizer(target: self, action: #selector(backToSignInTouched(sender:)))
        backLabel.isUserInteractionEnabled = true
        backLabel.addGestureRecognizer(tapBackRecognizer)

        self.view.addSubview(backLabel)
    }

    // MARK: Event Handler Touches
    @objc func registerButtonTouched(sender: UIButton) {
        print("REGISTER")
    }

    @objc func backToSignInTouched(sender: UITapGestureRecognizer) {
        print("FORGOT PASSWORD")
        self.performSegue(withIdentifier: SegueNameConstant.RegisterToLogin, sender: nil)
    }
}

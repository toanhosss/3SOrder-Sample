//
//  CustomInputField.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

class CustomInputField: UIView {

    var icon: UIImageView!
    var inputTextField: UITextField!

    private var _isSecureText: Bool = false
    var isSecureText: Bool {
        get {
            return _isSecureText
        }

        set {
            _isSecureText = newValue
            inputTextField.isSecureTextEntry = _isSecureText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        icon = UIImageView(frame: CGRect(x: self.frame.width*0.053598, y: self.frame.height*0.275, width: self.frame.width*0.095, height: self.frame.height*0.45))
        self.addSubview(icon)

        inputTextField = UITextField(frame: CGRect(x: icon.frame.origin.x + icon.frame.width + self.frame.width*0.09, y: 0, width: self.frame.width-icon.frame.width, height: self.frame.height))
        self.addSubview(inputTextField)
    }

    convenience init(frame: CGRect, icon: UIImage) {
        self.init(frame: frame)
        self.icon.image = icon
        self.icon.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

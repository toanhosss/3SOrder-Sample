//
//  CustomInputField.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/23/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

enum InputTextFieldType: Int {
    case hoshi
    case akira
    case isao
    case jiro
    case kaede
    case madoka
    case minoru
    case yoko
    case yoshiko
    case standard
}

enum KeyType: Int {
    case standard
    case name
    case phone
    case password
    case url
}

class CustomInputField: UIView {

    var icon: UIImageView!
    var inputTextField: AnyObject!

    var inputType: InputTextFieldType = .standard {
        didSet {
            switch self.inputType {
            case .hoshi:
                let newInputTextField = HoshiTextField(frame: (inputTextField as? UITextField)!.frame)
                inputTextField = newInputTextField
            case .isao:
                let newInputTextField = IsaoTextField(frame: (inputTextField as? UITextField)!.frame)
                inputTextField = newInputTextField
            case .jiro:
                let newInputTextField = JiroTextField(frame: (inputTextField as? UITextField)!.frame)
                inputTextField = newInputTextField
            default:
                inputTextField = UITextField()
            }
        }
    }

    var keytype: KeyType = .standard {
        didSet {
            switch self.keytype {
            case .phone:
                (self.inputTextField as? UITextField)!.keyboardType = .numberPad
            case .password:
                (self.inputTextField as? UITextField)!.keyboardType = .default
                (self.inputTextField as? UITextField)!.isSecureTextEntry = true
            default:
                (self.inputTextField as? UITextField)!.keyboardType = .default
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        inputTextField = UITextField(frame: CGRect(x: self.frame.width*0.05, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview((inputTextField as? UITextField)!)
    }

    convenience init(frame: CGRect, icon: UIImage) {
        self.init(frame: frame)
        self.icon = UIImageView(frame: CGRect(x: self.frame.width*0.053598, y: self.frame.height*0.275, width: self.frame.width*0.095, height: self.frame.height*0.45))
        (inputTextField as? UITextField)!.frame = CGRect(x: self.icon.frame.origin.x + self.icon.frame.width, y: 0, width: self.frame.width - self.icon.frame.width, height: self.frame.height)
        self.addSubview(self.icon)
        self.icon.image = icon
        self.icon.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ImageviewExtension.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/13/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setKingfisherImage(with resource: Resource?, placeholder: Image? = nil) {
        self.kf.setImage(with: resource, placeholder: placeholder, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
}

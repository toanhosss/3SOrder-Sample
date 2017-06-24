//
//  StringExtension.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 6/25/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import UIKit

extension String {

    /*
     * Get Width of text
     * - Input
     *   + text: String - not null, text to get width
     *   + maxSize: CGSize - max width limit
     * - Output
     *   + return new value for width
     */
     func getWidthFromText(maxSize: CGSize, minSize: CGSize?, font: UIFont) -> CGFloat {
        if minSize != nil && self.characters.count == 1 {
            return minSize!.width
        }

        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size.width
    }
}

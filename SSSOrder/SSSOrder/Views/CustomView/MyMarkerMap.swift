//
//  CustomMarkerMap.swift
//  piXMobile
//
//  Created by Toan Ho on 5/11/17.
//  Copyright © 2017 PI.EXCHANGE PTY LTD. All rights reserved.
//

import UIKit

class MyMarkerMap: UIImageView {

    private var _markerHighlight: Bool = false
    var markerHightlight: Bool {
        get {
            return _markerHighlight
        }

        set {
            _markerHighlight = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircleView()
    }

    /*
     * Init circleView
     */
    func createCircleView(status: Bool = false) {
        let minSize = self.frame.width >= self.frame.height ? self.frame.height:self.frame.width
        let sizeRatio: CGFloat = status ? 0.65:0.6
        for i in 0..<4 {
            let rate: CGFloat = sizeRatio - CGFloat(i)*0.16
            let size = minSize*rate
            let left = (self.frame.width - size)*0.5
            let top = (self.frame.height - size)*0.5
            let circleView = UIView(frame: CGRect(x: left, y: top, width: size, height: size))

            if i == 3 {
                circleView.backgroundColor = UIColor.white
            } else {
                circleView.backgroundColor = UIColor.hexStringToUIColor(status ? "#00bcd4":"#8f8f8f", alpha: status ? (0.3 + CGFloat(i)*0.15):(0.2 + CGFloat(i)*0.15))
            }

            circleView.layer.cornerRadius = 0.5*circleView.frame.width

            self.addSubview(circleView)
        }
    }

    /*
     * Update marker status
     */
    func updateMarkerHighlight(status: Bool) {
        for circleItem in self.subviews {
            circleItem.removeFromSuperview()
        }
        createCircleView(status: status)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CalendarCollectionViewCell.swift
//  SSSOrder
//
//  Created by Xuan Toan Ho on 7/9/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    var day: UILabel!
    var dayName: UILabel!

    var itemSelected: Bool = false {
        didSet {
            updateBackground()
        }
    }

    var defaultbackground = UIColor.white
    var isCanSelect: Bool = true {
        didSet {
            if self.isCanSelect {
                defaultbackground = UIColor.white
            } else {
                defaultbackground = UIColor.lightGray
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = ScreenSize.ScreenWidth/7
        let height = ScreenSize.ScreenHeight*0.1

        day = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height*0.65))
        day.textAlignment = .center
        day.font = UIFont.systemFont(ofSize: 25)
        dayName = UILabel(frame: CGRect(x: 0, y: height*0.6, width: width, height: height*0.3))
        dayName.textAlignment = .center

        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor

        contentView.addSubview(day)
        contentView.addSubview(dayName)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateBackground() {
        if itemSelected {
            contentView.backgroundColor = ColorConstant.BackgroundColor
            day.textColor = .white
            dayName.textColor = .white

        } else {
            contentView.backgroundColor = defaultbackground
//            if self.dayName.text != nil && (self.dayName.text! == "Sat" || self.dayName.text! == "Sun") {
//                day.textColor = .red
//                dayName.textColor = .red
//            } else {
                day.textColor = .black
                dayName.textColor = .black
//            }
        }
    }
}

class MyCalendarObject: NSObject {
    var date: String
    var dateFull: String
    var dateData: Date
    var canSelected: Bool = true

    init(date: String, dateFull: String, dateData: Date) {
        self.date = date
        self.dateFull = dateFull
        self.dateData = dateData
    }

    func getDayNumber() -> Int {
        let dateSplit = date.components(separatedBy: ",")
        return Int(dateSplit[1])!
    }

    func getEraString() -> String {
        return date.components(separatedBy: ",")[0]
    }
}

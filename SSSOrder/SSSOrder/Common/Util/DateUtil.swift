//
//  DateUtil.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/29/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
class DateUtil: NSObject {

    static func calicuateDaysBetweenTwoDates(start: Date, end: Date) -> Int {

        var currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }

    static func convertDateToFullLongDate(date: Date) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "EEEE, MMMM dd, yyy"
        return dateformat.string(from: date)
    }

    static func convertDateToFullLongDate(with stringDate: String, formatInput: String) -> String? {
        let dateformat = DateFormatter()
        dateformat.dateFormat = formatInput
        let date = dateformat.date(from: stringDate)
        if date == nil {
            return nil
        }
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "EEEE, MMMM dd, yyy"

        return outputFormat.string(from: date!)
    }
}

//
//  DateUtil.swift
//  SSSOrder
//
//  Created by Toan Ho on 6/29/17.
//  Copyright © 2017 ToanHo. All rights reserved.
//

import Foundation
import DateToolsSwift

class DateUtil: NSObject {

    static func calicuateDaysBetweenTwoDates(start: Date, end: Date) -> Int {

        let currentCalendar = Calendar.current
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

    static func getcurrentTimeStamp(with stringDateTime: String, input: String) -> Int64? {
        let dateformat = DateFormatter()
        dateformat.dateFormat = input
        let date = dateformat.date(from: stringDateTime)
        if date == nil {
            return nil
        }

        return Int64(date!.timeIntervalSince1970 * 1000)
    }

    static func convertDateTimeFromStringWithFormatInputOutput(with stringDateTime: String, input: String, output: String) -> String? {

        let dateformat = DateFormatter()
        dateformat.dateFormat = input
        let date = dateformat.date(from: stringDateTime)
        if date == nil {
            return nil
        }
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = output

        return outputFormat.string(from: date!)
    }

    static func convertDateTimeFromStringToDateTimeAgo(dateString: String, format input: String) -> String {

        let dateformat = DateFormatter()
        dateformat.dateFormat = input
        let date = dateformat.date(from: dateString)
        if date == nil {
            return dateString
        }

        let outPut = date!.timeAgoSinceNow

        return outPut
    }
}

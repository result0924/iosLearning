//
//  H2SDateTransformer.swift
//  corePlotTest
//
//  Created by jlai on 2023/12/9.
//  Copyright © 2023 h2. All rights reserved.
//

import Foundation

struct H2SDateTransformer: H2SDateTransformable {}

enum DateTransferError: Error {
    case invalidFormat
}

protocol H2SDateTransformable: Sendable {
    func utcDate(from dateText: String, format: String) throws -> Date
    func localDate(from dateText: String, format: String) throws -> Date

    func utcString(from date: Date, format: String) -> String
    func localString(from date: Date, format: String) -> String

    func utcDate(from date: Date) throws -> Date
}

extension H2SDateTransformable {

    var dateUTCFormatterName: String { "h2s_dateUTCDateFormatter" }

    var dateLocalFormatterName: String { "h2s_dateLocalDateFormatter" }

    var dateTimeFormat: String { "yyyy-MM-dd'T'HH:mm:ssZZZ" }

    var dateTimeWithoutZFormat: String { "yyyy-MM-dd'T'HH:mm:ss" }

    var dateFormat: String { "yyyy-MM-dd" }

    var utcDateFormatter: DateFormatter {
        guard let formatter = getCachedDateFormatter(name: dateUTCFormatterName) else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.calendar = Calendar(identifier: .gregorian)
            let threadDictionary = Thread.current.threadDictionary
            threadDictionary[dateUTCFormatterName] = formatter
            return formatter
        }
        return formatter
    }

    var localDateFormatter: DateFormatter {
        guard let formatter = getCachedDateFormatter(name: dateLocalFormatterName) else {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.calendar = Calendar(identifier: .gregorian)
            let threadDictionary = Thread.current.threadDictionary
            threadDictionary[dateLocalFormatterName] = formatter
            return formatter
        }
        return formatter
    }

    func utcDate(from dateText: String, format: String) throws -> Date {
        let formatter = utcDateFormatter
        formatter.dateFormat = format
        guard let date = formatter.date(from: dateText) else {
            throw DateTransferError.invalidFormat
        }
        return date
    }

    func localDate(from dateText: String, format: String) throws -> Date {
        let formatter = localDateFormatter
        formatter.dateFormat = dateTimeFormat
        guard let date = formatter.date(from: dateText) else {
            throw DateTransferError.invalidFormat
        }
        return date
    }

    func utcString(from date: Date, format: String) -> String {
        utcDateFormatter.dateFormat = format
        return utcDateFormatter.string(from: date)
    }

    func localString(from date: Date, format: String) -> String {
        localDateFormatter.dateFormat = format
        return localDateFormatter.string(from: date)
    }

    func utcDate(from date: Date) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let year = components.year, let month = components.month, let day = components.day else {
            throw DateTransferError.invalidFormat
        }

        let dateString = "\(year)-\(month)-\(day)"
        do {
            return try utcDate(from: dateString, format: dateFormat)
        } catch {
            throw DateTransferError.invalidFormat
        }
    }

    private func getCachedDateFormatter(name: String) -> DateFormatter? {
        let threadDictionary = Thread.current.threadDictionary
        guard let formatter = threadDictionary[name] as? DateFormatter else {
            return nil
        }
        return formatter
    }
}

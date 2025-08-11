//
//  Date+.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation

extension Date {
    func string(withFormat format: String = "HH:mm dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
    //        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: self)
    }
    
    func stringIsoDate(_ formatOptions: ISO8601DateFormatter.Options = [.withFullDate, .withFullTime, .withFractionalSeconds]) -> String {
        let isoFormat = ISO8601DateFormatter()
        isoFormat.formatOptions = formatOptions
        isoFormat.timeZone = TimeZone.current
        return isoFormat.string(from: self)
    }
    
    func numberDaysAgo(_ number: Int) -> Date? {
        let calendar = Calendar.current
        
        guard let daysAgoDate = calendar.date(byAdding: .day, value: -number, to: self) else {
            return nil
        }
        var components = calendar.dateComponents(in: TimeZone.current, from: daysAgoDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        let startOfDaysAgo = calendar.date(from: components)
        return startOfDaysAgo
    }
}

//
//  Date+Extension.swift
//  Utils
//
//  Created by 공태웅 on 5/5/25.
//

import Foundation

public extension Date {
    func monthDayString(locale: Locale = .current) -> String {
        if locale.isLanguageKorean {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "M월 d일"
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.locale = locale
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
    }
    
    func yearMonthDayString(locale: Locale = .current) -> String {
        let formatter = DateFormatter()
            .dateFormat("yyyy.M.d")
            .locale(Locale.current)
        return formatter.string(from: self)
    }
    
    func timeString(locale: Locale = .current) -> String {
        if locale.isLanguageKorean {
            return self.formatted(
                Date.FormatStyle()
                    .locale(locale)
                    .hour(.defaultDigits(amPM: .wide))
                    .minute(.twoDigits)
            )
        } else {
            return self.formatted(
                Date.FormatStyle()
                    .locale(locale)
                    .hour(.defaultDigits(amPM: .abbreviated))
                    .minute(.twoDigits)
            )
        }
    }
}

//
//  DateFormatter+Extension.swift
//  CommonUI
//
//  Created by 공태웅 on 4/20/25.
//

import Foundation

public extension DateFormatter {
    func dateFormat(_ format: String) -> Self {
        self.dateFormat = format
        return self
    }
    
    func locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }
}

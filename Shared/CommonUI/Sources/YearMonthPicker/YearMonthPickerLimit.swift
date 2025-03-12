//
//  YearMonthPickerLimit.swift
//  CommonUI
//
//  Created by 공태웅 on 3/12/25.
//

import Foundation

public struct YearMonthPickerLimit {
    
    // MARK: Lifecycle
    
    public init(minimumYear: Int, minimumMonth: Int, currentYear: Int, currentMonth: Int) {
        self.minimumYear = minimumYear
        self.minimumMonth = minimumMonth
        self.currentYear = currentYear
        self.currentMonth = currentMonth
    }
    
    // MARK: Properties
    
    let minimumYear: Int
    let minimumMonth: Int
    let currentYear: Int
    let currentMonth: Int
}

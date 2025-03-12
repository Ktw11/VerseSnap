//
//  YearMonthPickerView.swift
//  CommonUI
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI

public struct YearMonthPickerView: View {
    
    // MARK: LifeCycle
    
    public init(
        selectedYear: Binding<Int>,
        selectedMonth: Binding<Int>,
        isPresenting: Binding<Bool>,
        limit: YearMonthPickerLimit
    ) {
        self._selectedYear = selectedYear
        self._selectedMonth = selectedMonth
        self._isPresenting = isPresenting
        self.limit = limit
    }
    
    // MARK: Properties
    
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    @Binding var isPresenting: Bool
    
    private let limit: YearMonthPickerLimit
    
    private var years: [Int] {
        Array(limit.minimumYear...limit.currentYear)
    }
    private var months: [Int] {
        availableMonths(selectedYear)
    }

    private var selectedYearWrapper: Binding<Int> {
        Binding(
            get: { self.selectedYear },
            set: { newValue in
                let validMonths = availableMonths(newValue)

                if validMonths.contains(selectedMonth) {
                    self.selectedYear = newValue
                } else {
                    self.selectedYear = newValue
                    self.selectedMonth = validMonths.first ?? newValue
                }
            }
        )
    }
 
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isPresenting = false
                }
            
            HStack(spacing: 0) {
                Picker(
                    selection: selectedYearWrapper,
                    content: {
                        ForEach(years, id: \.self) { year in
                            Text(verbatim: "\(year)년")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }, label: {
                        Color.clear
                    }
                )
                .pickerStyle(.wheel)

                Picker(
                    selection: $selectedMonth,
                    content: {
                        ForEach(months, id: \.self) { months in
                            Text(verbatim: "\(months)월")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }, label: {
                        Color.clear
                    }
                )
                .pickerStyle(.wheel)
            }
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .ignoresSafeArea()
        .presentationBackground(.clear)
    }
    
    // MARK: Methods
    
    private func availableMonths(_ selectedYear: Int) -> [Int] {
        if selectedYear == limit.minimumYear && selectedYear == limit.currentYear {
            return Array(limit.minimumMonth...limit.currentMonth)
        } else if selectedYear == limit.minimumYear {
            return Array(limit.minimumMonth...12)
        } else if selectedYear == limit.currentYear {
            return Array(1...limit.currentMonth)
        } else {
            return Array(1...12)
        }
    }
    
    private func isValidMonth(selectedYear: Int, selectedMonth: Int) -> Bool {
        return availableMonths(selectedYear).contains(selectedMonth)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var selectedYear: Int = 2024
    @State private var selectedMonth: Int = 11
    @State private var isShowingPicker: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(String(selectedYear))
                Text(String(selectedMonth))
            }
            
            YearMonthPickerView(
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth,
                isPresenting: $isShowingPicker,
                limit: .init(
                    minimumYear: 2020,
                    minimumMonth: 5,
                    currentYear: 2025,
                    currentMonth: 3
                )
            )
        }
    }
}

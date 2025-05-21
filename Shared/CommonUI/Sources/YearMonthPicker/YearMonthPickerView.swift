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
    @State private var localSelectedYear: Int = .zero
    @State private var localSelectedMonth: Int = .zero
    @Binding var isPresenting: Bool
    
    private let limit: YearMonthPickerLimit
    
    private var years: [Int] {
        Array(limit.minimumYear...limit.currentYear)
    }
    private var months: [Int] {
        availableMonths(localSelectedYear)
    }

    private var selectedYearWrapper: Binding<Int> {
        Binding(
            get: { self.localSelectedYear },
            set: { newValue in
                let validMonths = availableMonths(newValue)

                if validMonths.contains(localSelectedMonth) {
                    self.localSelectedYear = newValue
                } else {
                    self.localSelectedYear = newValue
                    self.localSelectedMonth = validMonths.first ?? newValue
                }
            }
        )
    }
 
    public var body: some View {
        VStack(spacing: 10) {
            pickers()
            
            Button(action: {
                isPresenting.toggle()
            }, label: {
                CommonUIAsset.Color.buttonBG.swiftUIColor
                    .clipShape(Capsule())
                    .overlay {
                        Text("확인")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(.white)
                    }
            })
            .frame(height: 50)
            .padding([.horizontal, .bottom], 15)
        }
        .onAppear {
            localSelectedYear = selectedYear
            localSelectedMonth = selectedMonth
        }
        .onDisappear {
            selectedYear = localSelectedYear
            selectedMonth = localSelectedMonth
        }
    }
    
    // MARK: Methods
    
    @ViewBuilder
    private func pickers() -> some View {
        HStack(spacing: 0) {
            Group {
                Picker(selection: selectedYearWrapper, label: EmptyView()) {
                    ForEach(years, id: \.self) { year in
                        #warning("번역 필요")
                        Text(verbatim: "\(year)년")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }

                Picker(selection: $localSelectedMonth, label: EmptyView()) {
                    ForEach(months, id: \.self) { months in
                        #warning("번역 필요")
                        Text(verbatim: "\(months)월")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }
            }
            .pickerStyle(.wheel)
        }
    }
    
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
            .onTapGesture {
                isShowingPicker = true
            }
            
            Spacer()
        }
        .modalView($isShowingPicker) {
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

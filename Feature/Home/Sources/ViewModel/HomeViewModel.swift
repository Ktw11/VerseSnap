//
//  HomeViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI
import CommonUI

@Observable
@MainActor
public final class HomeViewModel {
    
    // MARK: Lifecycle
    
    init(calendar: Calendar) {
        let diaries: [Diary] = [
            .init(
                photo: HomeAsset.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: false,
                firstCharacters: "삼/행/시"
            ),
            .init(
                photo: HomeAsset.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: true,
                firstCharacters: "삼/행/시"
            ),
            .init(
                photo: HomeAsset.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: false,
                firstCharacters: "사/행/시/시"
            ),
            .init(
                photo: HomeAsset.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: false,
                firstCharacters: "삼/행/1"
            ),
            .init(
                photo: HomeAsset.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: false,
                firstCharacters: "삼/행/2"
            )
        ]
        
        self.calendar = calendar
        self.diaries = diaries
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        self.selectedYear = currentYear
        self.selectedMonth = currentMonth
        self.pickerLimit = YearMonthPickerLimit(
            minimumYear: 2020,
            minimumMonth: 9,
            currentYear: currentYear,
            currentMonth: currentMonth
        )
    }
    
    // MARK: Properties
    
    var selectedYear: Int
    var selectedMonth: Int
    var displayStyle: DisplayStyle = .stack
    let pickerLimit: YearMonthPickerLimit
    
    var yearMonthString: String {
        "\(selectedYear).\(selectedMonth)"
    }
    var displayIcon: Image {
        displayStyle == .stack ? HomeAsset.icGridDisplay.swiftUIImage : HomeAsset.icStackDisplay.swiftUIImage
    }
    var rowViewModels: [HomeContentRowViewModel] {
        makeRowViewModels()
    }
    var gridViewModels: [HomeContentGridViewModel] {
        makeGridViewModels()
    }
    
    private var isCurrentYearMonthSelected: Bool {
        selectedYear == currentYear && selectedMonth == currentMonth
    }
    
    private let currentYear: Int
    private let currentMonth: Int
    private let calendar: Calendar
    private var diaries: [Diary]
    
    // MARK: Methods
    
    func didTapDisplayIcon() {
        displayStyle.toggle()
    }
}

private extension HomeViewModel {
    func makeRowViewModels() -> [HomeContentRowViewModel] {
        var wroteDiaryToday: Bool = false
        
        var viewModels: [HomeContentRowViewModel] = diaries
            .filter { selectedYear == calendar.component(.year, from: $0.createdAt) && selectedMonth == calendar.component(.month, from: $0.createdAt) }
            .reduce(into: []) { result, diary in
                if calendar.isDateInToday(diary.createdAt) {
                    wroteDiaryToday = true
                }
                result.append(diary.toRowViewModel)
            }
        
        if !wroteDiaryToday && isCurrentYearMonthSelected {
            viewModels.insert(.placeholder, at: 0)
        }
        
        return viewModels
    }
    
    func makeGridViewModels() -> [HomeContentGridViewModel] {
        diaries.map(\.toGridViewModel)
    }
}

#warning("임시 구조체 - 제거 필요")
struct Diary: Equatable {
    let id: UUID = .init()
    let photo: Image
    let createdAt: Date
    let isFavorite: Bool
    let firstCharacters: String
}

extension Diary {
    var toRowViewModel: HomeContentRowViewModel {
        .init(
            id: id.uuidString,
            photoContainerViewModel: .init(
                image: photo,
                topTitle: "16",
                bottomTitle: "Mon"
            ),
            title: "6월 17일",
            description: firstCharacters,
            timeString: "오후 12:30",
            actionIcon: isFavorite ? HomeAsset.icHeartFill.swiftUIImage : HomeAsset.icHeartEmpty.swiftUIImage
        )
    }
    
    var toGridViewModel: HomeContentGridViewModel {
        .init(
            id: id.uuidString,
            image: photo,
            favoriteIcon: isFavorite ? HomeAsset.icHeartFill.swiftUIImage : HomeAsset.icHeartEmpty.swiftUIImage
        )
    }
}

extension HomeContentRowViewModel {
    static var placeholder: HomeContentRowViewModel {
        .init(
            id: UUID().uuidString,
            photoContainerViewModel: .init(image: nil, topTitle: nil, bottomTitle: "Today"),
            title: String(localized: "오늘의 삼행시"),
            description: String(localized: "기록하기"),
            timeString: nil,
            actionIcon: HomeAsset.icPlus.swiftUIImage
        )
    }
}

extension DisplayStyle {
    mutating func toggle() {
        switch self {
        case .grid:
            self = .stack
        case .stack:
            self = .grid
        }
    }
}

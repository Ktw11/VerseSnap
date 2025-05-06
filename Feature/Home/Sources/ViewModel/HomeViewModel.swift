//
//  HomeViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI
import CommonUI
import Utils
import Domain

@Observable
@MainActor
public final class HomeViewModel {
    
    // MARK: Lifecycle
    
    init(calendar: Calendar, useCase: DiaryUseCase) {
        self.calendar = calendar
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        self.currentYear = currentYear
        self.currentMonth = currentMonth
        self.selectedYear = currentYear
        self.selectedMonth = currentMonth
        #warning("minimumYear, minimumMonth")
        self.pickerLimit = YearMonthPickerLimit(
            minimumYear: 2020,
            minimumMonth: 9,
            currentYear: currentYear,
            currentMonth: currentMonth
        )
        self.useCase = useCase
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let cursorSize: Int = 20
        static let weekdaySymbols: [LocalizedStringResource] = [
            "mon", "tue", "wed", "thu", "fri", "sat", "sun"
        ]
    }
    
    // MARK: Properties
    
    var selectedYear: Int {
        didSet { resetAndFetch(year: selectedYear, month: selectedMonth) }
    }
    var selectedMonth: Int {
        didSet { resetAndFetch(year: selectedYear, month: selectedMonth) }
    }
    
    var displayStyle: DisplayStyle = .stack
    let pickerLimit: YearMonthPickerLimit
    
    var yearMonthString: String {
        "\(selectedYear).\(selectedMonth)"
    }
    var displayIcon: Image {
        displayStyle == .stack ? HomeAsset.icGridDisplay.swiftUIImage : HomeAsset.icStackDisplay.swiftUIImage
    }
    var gridViewModels: [HomeContentGridViewModel] {
        makeGridViewModels()
    }
    var showRowViewLoading: Bool {
        isFetchingMonthlyDiary && rowViewModels.isEmpty
    }
    
    // Diaries by month
    var rowViewModels: [HomeContentRowViewModel] {
        internalRowViewModels.withPlaceholder(isCurrentYearMonth: isCurrentYearMonthSelected)
    }
    private(set) var isFetchingMonthlyDiary: Bool = false
    private(set) var isErrorOccured: Bool = false
    private(set) var isMonthlyDiaryLastPage: Bool = false
    private var internalRowViewModels: [HomeContentRowViewModel] = []
    private var monthlyCursor: DiaryCursor = .init(size: Constants.cursorSize, lastCreatedAt: nil)
    private var monthlyDiariesTask: Task<Void, Error>?
    
    private var isCurrentYearMonthSelected: Bool {
        selectedYear == currentYear && selectedMonth == currentMonth
    }
    
    private let currentYear: Int
    private let currentMonth: Int
    private let calendar: Calendar
    private let useCase: DiaryUseCase
    #warning("임시 구조체, 제거 필요")
    private var diaries: [Diary] = []

    // MARK: Methods
    
    func didTapDisplayIcon() {
        displayStyle.toggle()
    }
    
    func fetchNextMonthlyDiaries() {
        guard !isFetchingMonthlyDiary, !isMonthlyDiaryLastPage else { return }

        let yearMonth: YearMonth = .init(year: selectedYear, month: selectedMonth)
        isFetchingMonthlyDiary = true
        isErrorOccured = false
        
        monthlyDiariesTask = Task { [weak self, useCase, monthlyCursor] in
            defer {
                if !Task.isCancelled {
                    self?.isFetchingMonthlyDiary = false
                }
            }
            
            do {
                try Task.checkCancellation()
                
                let result = try await useCase.fetchDiariesByMonth(year: yearMonth.year, month: yearMonth.month, after: monthlyCursor)
                let viewModels = await Task.detached(priority: .userInitiated) { [weak self] in
                    self?.makeRowViewModelList(from: result.diaries) ?? []
                }.value
                
                try Task.checkCancellation()

                self?.internalRowViewModels.append(contentsOf: viewModels)
                self?.monthlyCursor = DiaryCursor(size: Constants.cursorSize, lastCreatedAt: result.diaries.last?.createdAt)
                self?.isMonthlyDiaryLastPage = result.isLastPage
            } catch {
                #warning("error 핸들링 필요")
            }
        }
    }
}

private extension HomeViewModel {
    func resetAndFetch(year: Int, month: Int) {
        monthlyDiariesTask?.cancel()
        monthlyCursor = DiaryCursor(size: Constants.cursorSize, lastCreatedAt: nil)
        internalRowViewModels = []
        isErrorOccured = false
        isFetchingMonthlyDiary = false
        isMonthlyDiaryLastPage = false

        fetchNextMonthlyDiaries()
    }
    
    nonisolated func makeRowViewModelList(from diaries: [VerseDiary]) -> [HomeContentRowViewModel] {
        return diaries.map(makeRowViewModel)
    }
    
    nonisolated func makeRowViewModel(for diary: VerseDiary) -> HomeContentRowViewModel {
        let createdDate: Date = Date(timeIntervalSince1970: diary.createdAt)
        let day: Int = calendar.component(.day, from: createdDate)
        let weekdayIndex: Int = calendar.component(.weekday, from: createdDate)
        
        return HomeContentRowViewModel(
            id: diary.id,
            photoContainerViewModel: .init(
                imageURL: diary.imageURL,
                topTitle: String(day),
                bottomTitle: Constants.weekdaySymbols[safe: weekdayIndex] ?? ""
            ),
            title: createdDate.monthDayString(),
            description: diary.verse.firstLetters(separator: "/"),
            timeString: createdDate.timeString(),
            actionIcon: diary.isFavorite ? HomeAsset.icHeartFill.swiftUIImage : HomeAsset.icHeartEmpty.swiftUIImage
        )
    }
    
    func makeGridViewModels() -> [HomeContentGridViewModel] {
        diaries.map(\.toGridViewModel)
    }
}

private extension [HomeContentRowViewModel] {
    func withPlaceholder(isCurrentYearMonth: Bool) -> [HomeContentRowViewModel] {
        guard isCurrentYearMonth else { return self }
        
        var newViewModels = self
        newViewModels.insert(.placeholder, at: 0)
        return newViewModels
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
            photoContainerViewModel: .init(imageURL: "", topTitle: nil, bottomTitle: "Today"),
            title: String(localized: "오늘의 삼행시"),
            description: String(localized: "기록하기"),
            timeString: nil,
            actionIcon: CommonUIAsset.Image.icPlus.swiftUIImage
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

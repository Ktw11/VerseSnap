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
    
    private var internalRowViewModels: [HomeContentRowViewModel] = []
    private var monthlyDiariesTask: Task<Void, Error>?
    private var monthlyPagingState: PagingState<DiaryCursor> = .initial
    
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
        guard !monthlyPagingState.isFetching, !monthlyPagingState.isLastPage else { return }

        let yearMonth: YearMonth = .init(year: selectedYear, month: selectedMonth)
        let cursor = monthlyPagingState.cursor ?? DiaryCursor(size: Constants.cursorSize, lastCreatedAt: nil)
        
        monthlyPagingState.update {
            $0.isFetching = true
            $0.isErrorOccured = false
        }
        
        monthlyDiariesTask = Task { [weak self, useCase] in
            defer {
                if !Task.isCancelled {
                    self?.monthlyPagingState.isFetching = false
                }
            }
            
            do {
                try Task.checkCancellation()
                
                let result = try await useCase.fetchDiariesByMonth(year: yearMonth.year, month: yearMonth.month, after: cursor)
                let viewModels = await Task.detached(priority: .userInitiated) { [weak self] in
                    self?.makeRowViewModelList(from: result.diaries) ?? []
                }.value
                
                try Task.checkCancellation()

                let lastCreatedAt: TimeInterval? = result.diaries.last?.createdAt
                self?.update(viewModels, lastCreatedAt: lastCreatedAt, isLastPage: result.isLastPage)
            } catch _ as CancellationError {
                // do nothing
            } catch {
                self?.monthlyPagingState.isErrorOccured = true
            }
        }
    }
}

extension HomeViewModel {
    var yearMonthString: String {
        "\(selectedYear).\(selectedMonth)"
    }
    var displayIcon: Image {
        displayStyle == .stack ? HomeAsset.icGridDisplay.swiftUIImage : HomeAsset.icStackDisplay.swiftUIImage
    }
    var gridViewModels: [HomeContentGridViewModel] {
        makeGridViewModels()
    }
    
    // Diaries by month
    var isStackDisplayLoading: Bool {
        monthlyPagingState.isFetching && rowViewModels.isEmpty
    }
    var rowViewModels: [HomeContentRowViewModel] {
        internalRowViewModels.withPlaceholder(isCurrentYearMonth: isCurrentYearMonthSelected)
    }
    var showLoadingRowView: Bool {
        !monthlyPagingState.isLastPage && !monthlyPagingState.isErrorOccured
    }
    var isMonthlyDiaryEmpty: Bool {
        monthlyPagingState.isEmpty
    }
    var isMonthlyErrorOccured: Bool {
        monthlyPagingState.isErrorOccured
    }
}

private extension HomeViewModel {
    func resetAndFetch(year: Int, month: Int) {
        monthlyDiariesTask?.cancel()
        monthlyPagingState = .initial
        internalRowViewModels = []

        fetchNextMonthlyDiaries()
    }
    
    @MainActor
    func update(_ viewModels: [HomeContentRowViewModel], lastCreatedAt: TimeInterval?, isLastPage: Bool) {
        internalRowViewModels.append(contentsOf: viewModels)

        monthlyPagingState.update {
            $0.isLastPage = isLastPage
            $0.isEmpty = internalRowViewModels.isEmpty
            $0.cursor = DiaryCursor(size: Constants.cursorSize, lastCreatedAt: lastCreatedAt)
        }
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

private extension PagingState {
    mutating func update(_ closure: (inout PagingState) -> Void) {
        closure(&self)
    }
}

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
    
    private var internalStackViewModels: [HomeStackContentViewModel] = []
    private var stackDiariesTask: Task<Void, Never>?
    private var stackPagingState: PagingState<DiaryCursor> = .initial
    
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
    
    func fetchNextStackDiaries(byUser: Bool = false) {
        guard stackPagingState.canStartFetch(byUser: byUser) else { return }
        
        stackPagingState.update {
            $0.isFetching = true
            $0.isErrorOccured = false
        }
        
        let cursor: DiaryCursor = stackPagingState.cursor ?? DiaryCursor(size: Constants.cursorSize, lastCreatedAt: nil)
        stackDiariesTask = fetchStackDiariesTask(year: selectedYear, month: selectedMonth, cursor: cursor)
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
        stackPagingState.isFetching && internalStackViewModels.isEmpty
    }
    var stackViewModels: [HomeStackContentViewModel] {
        internalStackViewModels.withPlaceholder(isCurrentYearMonth: isCurrentYearMonthSelected)
    }
    var showLoadingStackView: Bool {
        !stackPagingState.isLastPage && !stackPagingState.isErrorOccured
    }
    var isStackDiaryEmpty: Bool {
        stackPagingState.isEmpty
    }
    var isStackErrorOccured: Bool {
        stackPagingState.isErrorOccured
    }
}

private extension HomeViewModel {
    func resetAndFetch(year: Int, month: Int) {
        stackDiariesTask?.cancel()
        stackPagingState = .initial
        internalStackViewModels = []

        fetchNextStackDiaries()
    }
    
    @MainActor
    func update(_ viewModels: [HomeStackContentViewModel], lastCreatedAt: TimeInterval?, isLastPage: Bool) {
        internalStackViewModels.append(contentsOf: viewModels)

        stackPagingState.update {
            $0.isLastPage = isLastPage
            $0.isEmpty = internalStackViewModels.isEmpty
            $0.cursor = DiaryCursor(size: Constants.cursorSize, lastCreatedAt: lastCreatedAt)
        }
    }
    
    nonisolated func makeStackViewModelList(from diaries: [VerseDiary]) -> [HomeStackContentViewModel] {
        return diaries.map(makeStackViewModel)
    }
    
    nonisolated func makeStackViewModel(for diary: VerseDiary) -> HomeStackContentViewModel {
        let createdDate: Date = Date(timeIntervalSince1970: diary.createdAt)
        let day: Int = calendar.component(.day, from: createdDate)
        let weekdayIndex: Int = calendar.component(.weekday, from: createdDate)
        
        return HomeStackContentViewModel(
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

    func fetchStackDiariesTask(year: Int, month: Int, cursor: DiaryCursor) -> Task<Void, Never> {
        Task { [weak self, useCase] in
            defer {
                if !Task.isCancelled {
                    self?.stackPagingState.isFetching = false
                }
            }
            
            do {
                try Task.checkCancellation()
                
                let result = try await useCase.fetchDiaries(year: year, month: month, after: cursor)
                let viewModels = await Task.detached(priority: .userInitiated) { [weak self] in
                    self?.makeStackViewModelList(from: result.diaries) ?? []
                }.value
                
                try Task.checkCancellation()

                let lastCreatedAt: TimeInterval? = result.diaries.last?.createdAt
                self?.update(viewModels, lastCreatedAt: lastCreatedAt, isLastPage: result.isLastPage)
            } catch _ as CancellationError {
                // do nothing
            } catch {
                self?.stackPagingState.isErrorOccured = true
            }
        }
    }
}

private extension [HomeStackContentViewModel] {
    func withPlaceholder(isCurrentYearMonth: Bool) -> [HomeStackContentViewModel] {
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

extension HomeStackContentViewModel {
    static var placeholder: HomeStackContentViewModel {
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
    func canStartFetch(byUser: Bool) -> Bool {
        if byUser {
            return !isFetching && !isLastPage
        } else {
            return !isFetching && !isLastPage && !isErrorOccured
        }
    }

    mutating func update(_ closure: (inout PagingState) -> Void) {
        closure(&self)
    }
}

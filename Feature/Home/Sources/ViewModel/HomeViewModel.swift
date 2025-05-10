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
public final class HomeViewModel: Sendable {
    
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
        
        self.stackPagingController = HomeDiaryPagingController(
            viewModelFactory: HomeStackViewModelFactory(
                calendar: calendar
            ),
            cursorSize: Constants.cursorSize
        )
        self.gridPagingController = HomeDiaryPagingController(
            viewModelFactory: HomeGridViewModelFactory(),
            cursorSize: Constants.cursorSize
        )
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let cursorSize: Int = 20
    }
    
    // MARK: Properties
    
    var selectedYear: Int {
        didSet { resetAndRefreshStackPage() }
    }
    var selectedMonth: Int {
        didSet { resetAndRefreshStackPage() }
    }
    
    var displayStyle: DisplayStyle = .stack
    var presentingDetailViewModel: DetailDiaryViewModel?
    var isNewVersePresented: Bool = false
    let pickerLimit: YearMonthPickerLimit
    
    private var isCurrentYearMonthSelected: Bool {
        selectedYear == currentYear && selectedMonth == currentMonth
    }

    private var cachedDiaries: Set<VerseDiary> = []
    private let stackPagingController: HomeDiaryPagingController<HomeStackContentViewModel>
    private let gridPagingController: HomeDiaryPagingController<HomeGridContentViewModel>
    var favoriteTasks: Dictionary<String, Task<Void, Never>> = .init()
    private let currentYear: Int
    private let currentMonth: Int
    private let calendar: Calendar
    private let useCase: DiaryUseCase

    // MARK: Methods
    
    func didTapDisplayIcon() {
        displayStyle.toggle()
    }
    
    func fetchNextStackDiaries(byUser: Bool = false) {
        let year: Int = selectedYear
        let month: Int = selectedMonth
        
        stackPagingController.fetchNext(byUser: byUser) { [weak self, useCase] cursor in
            let result = try await useCase.fetchDiaries(year: year, month: month, after: cursor)
            await self?.updateCachedDiaries(Set(result.diaries))
            return result
        }
    }
    
    func fetchNextGridDiaries(byUser: Bool = false) {
        gridPagingController.fetchNext { [weak self, useCase] cursor in
            let result = try await useCase.fetchDiariesAll(after: cursor)
            await self?.updateCachedDiaries(Set(result.diaries))
            return result
        }
    }
    
    func didTapDiary(_ id: String) {
        guard id != HomeStackContentViewModel.Constants.placeholderId else {
            isNewVersePresented = true
            return
        }
        guard let diary = cachedDiaries.first(where: { $0.id == id }) else { return }
        
        presentingDetailViewModel = DetailDiaryViewModel(from: diary)
    }
    
    func didTapFavorite(to isFavorite: Bool, id: String) {
        if let updatingTask = favoriteTasks[id] {
            updatingTask.cancel()
        }
        
        updateDiary(id: id, isFavorite: isFavorite)
        
        let favoriteTask = Task.detached { [weak self, useCase] in
            defer {
                Task { @MainActor [weak self] in self?.favoriteTasks.removeValue(forKey: id) }
            }
            
            do {
                try Task.checkCancellation()
                try await useCase.updateFavorite(to: isFavorite, id: id)
            } catch {
                guard Task.isCancelled else { return }
                await self?.updateDiary(id: id, isFavorite: !isFavorite)
            }
        }
        
        favoriteTasks[id] = favoriteTask
    }
}

extension HomeViewModel {
    var yearMonthString: String {
        "\(selectedYear).\(selectedMonth)"
    }
    var displayIcon: Image {
        displayStyle == .stack ? HomeAsset.icGridDisplay.swiftUIImage : HomeAsset.icStackDisplay.swiftUIImage
    }

    // Diaries - Filtered by Month
    var stackViewModels: [HomeStackContentViewModel] {
        stackPagingController.viewModels
            .withPlaceholder(isCurrentYearMonth: isCurrentYearMonthSelected)
    }
    var isStackDisplayLoading: Bool {
        stackPagingController.isFetchingInitalPage
    }
    var showLoadingStackView: Bool {
        stackPagingController.showLoading
    }
    var isStackDiaryEmpty: Bool {
        stackPagingController.isEmpty
    }
    var isStackErrorOccured: Bool {
        stackPagingController.isErrorOccured
    }
    
    // Diaries - All
    var gridViewModels: [HomeGridContentViewModel] {
        gridPagingController.viewModels
    }
    var isGridDisplayLoading: Bool {
        gridPagingController.isFetchingInitalPage
    }
    var showLoadingGridView: Bool {
        gridPagingController.showLoading
    }
    var isGridDiaryEmpty: Bool {
        gridPagingController.isEmpty
    }
    var isGridErrorOccured: Bool {
        gridPagingController.isErrorOccured
    }
}

private extension HomeViewModel {
    func resetAndRefreshStackPage() {
        stackPagingController.reset()
        fetchNextStackDiaries()
    }
    
    func updateCachedDiaries(_ newDiaries: Set<VerseDiary>) {
        cachedDiaries.formUnion(Set(newDiaries))
    }
    
    func updateDiary(id: String, isFavorite: Bool) {
        gridPagingController.updateDiary(id: id, isFavorite: isFavorite)
        stackPagingController.updateDiary(id: id, isFavorite: isFavorite)
        
        if let diary = cachedDiaries.first(where: { $0.id == id }) {
            var updatedDiary = diary
            updatedDiary.isFavorite = isFavorite
            cachedDiaries.update(with: updatedDiary)
        }
    }
}

private extension [HomeStackContentViewModel] {
    @MainActor
    func withPlaceholder(isCurrentYearMonth: Bool) -> [HomeStackContentViewModel] {
        guard isCurrentYearMonth else { return self }
        
        var newViewModels = self
        newViewModels.insert(.placeholder, at: 0)
        return newViewModels
    }
}

private extension HomeStackContentViewModel {
    static var placeholder: HomeStackContentViewModel {
        .init(
            id: Constants.placeholderId,
            photoContainerViewModel: .init(imageURL: "", topTitle: nil, bottomTitle: "Today"),
            title: String(localized: "오늘의 삼행시"),
            description: String(localized: "기록하기"),
            timeString: nil,
            isFavorite: nil
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

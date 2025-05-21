//
//  HomeDiaryPagingController.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI
import Domain

@Observable
@MainActor
final class HomeDiaryPagingController<ViewModel: HomeContentViewModel> {
    
    // MARK: Properties
    
    init(
        viewModelFactory: any HomeContentViewModelFactory<ViewModel>,
        cursorSize: Int
    ) {
        self.viewModelFactory = viewModelFactory
        self.cursorSize = cursorSize
    }
    
    // MARK: Definitions
    
    typealias FetchDiaries = @Sendable (DiaryCursor) async throws -> DiaryFetchResult
    
    // MARK: Properties
    
    private(set) var viewModels: [ViewModel] = []
    private var pagingState: PagingState<DiaryCursor> = .initial
    private var fetchingTask: Task<Void, Never>?
    private let viewModelFactory: any HomeContentViewModelFactory<ViewModel>
    private let cursorSize: Int
    
    // MARK: Methods
    
    func fetchNext(
        byUser: Bool = false,
        fetchDiaries: @escaping FetchDiaries
    ) {
        guard pagingState.canStartFetch(byUser: byUser) else { return }
        
        pagingState.update {
            $0.isFetching = true
            $0.isErrorOccured = false
        }
        
        let cursor = pagingState.cursor ?? DiaryCursor(size: cursorSize, lastCreatedAt: nil)
        fetchingTask = makeFetchingTask(fetchDiaries, cursor: cursor)
    }
    
    func updateDiary(id: String, isFavorite: Bool) {
        guard let viewModel = viewModels.first(where: { $0.id == id }) else { return }
        viewModel.setFavorite(to: isFavorite)
    }
    
    func insertDiary(_ diary: VerseDiary, at index: Int) {
        let viewModel = viewModelFactory.build(from: diary)
        viewModels.insert(viewModel, at: index)
        pagingState.isEmpty = false
    }
    
    func reset() {
        fetchingTask?.cancel()
        pagingState = .initial
        viewModels = []
    }
}

extension HomeDiaryPagingController {
    var isFetchingInitalPage: Bool {
        pagingState.isFetching && viewModels.isEmpty
    }
    
    var showLoading: Bool {
        !pagingState.isLastPage && !pagingState.isErrorOccured
    }
    
    var isEmpty: Bool {
        pagingState.isEmpty
    }
    
    var isErrorOccured: Bool {
        pagingState.isErrorOccured
    }
}

private extension HomeDiaryPagingController {
    func makeFetchingTask(_ fetchDiaries: @escaping FetchDiaries, cursor: DiaryCursor) -> Task<Void, Never> {
        Task { [weak self] in
            defer {
                if !Task.isCancelled {
                    self?.pagingState.isFetching = false
                }
            }
            
            do {
                try Task.checkCancellation()
                
                let result = try await fetchDiaries(cursor)
                let viewModels: [ViewModel] = result.diaries.compactMap { self?.viewModelFactory.build(from: $0) }
                
                try Task.checkCancellation()
                
                let lastCreatedAt: TimeInterval? = result.diaries.last?.createdAt
                self?.update(viewModels, lastCreatedAt: lastCreatedAt, isLastPage: result.isLastPage)
            } catch _ as CancellationError {
                // do nothing
            } catch {
                self?.pagingState.isErrorOccured = true
            }
        }
    }
    
    func update(_ newViewModels: [ViewModel], lastCreatedAt: TimeInterval?, isLastPage: Bool) {
       viewModels.append(contentsOf: newViewModels)
       
       pagingState.update {
           $0.isLastPage = isLastPage
           $0.isEmpty = viewModels.isEmpty
           $0.cursor = DiaryCursor(size: cursorSize, lastCreatedAt: lastCreatedAt)
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

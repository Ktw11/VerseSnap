//
//  PagingStackView.swift
//  CommonUI
//
//  Created by 공태웅 on 5/6/25.
//

import SwiftUI

public struct PagingStackView<
    Item: Identifiable,
    Content: View,
    DividerView: View,
    ErrorView: View,
    LoadingView: View
>: View {
    
    // MARK: Lifecycle
    
    public init(
        items: [Item],
        isLoading: Bool?,
        isError: Bool?,
        stackType: PagingStackType,
        content: @escaping (Item) -> Content,
    ) {
        self.items = items
        self.isLoading = isLoading
        self.isError = isError
        self.stackType = stackType
        self.content = content
    }
    
    // MARK: Properties

    public var body: some View {
        ScrollView {
            switch stackType {
            case .vStack:
                LazyVStack {
                    pagingContent()
                }
            case .vGrid(let columns):
                LazyVGrid(columns: columns) {
                    pagingContent()
                }
            }
        }
    }
    
    private let items: [Item]
    private let isLoading: Bool?
    private let isError: Bool?
    private let stackType: PagingStackType
    private let content: (Item) -> Content
    
    private var onAppearLast: (() -> Void)?
    private var divider:  (() -> DividerView)?
    private var errorView: (() -> ErrorView)?
    private var loadingView: (() -> LoadingView)?
}

public extension PagingStackView {
    func onAppearLast(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.onAppearLast = action
        return view
    }
    
    func divider(@ViewBuilder _ divider: @escaping () -> DividerView) -> Self {
        var view = self
        view.divider = divider
        return view
    }
    
    func errorView(@ViewBuilder _ errorView: @escaping () -> ErrorView) -> Self {
        var view = self
        view.errorView = errorView
        return view
    }
    
    func loadingView(@ViewBuilder _ loadingView: @escaping () -> LoadingView) -> Self {
        var view = self
        view.loadingView = loadingView
        return view
    }
}

private extension PagingStackView {
    @ViewBuilder
    func pagingContent() -> some View {
        ForEach(items) { item in
            content(item)
                .onAppear {
                    if items.last?.id == item.id {
                        onAppearLast?()
                    }
                }
            
            if let divider, items.last?.id != item.id {
                divider()
            }
        }
        
        Group {
            if let errorView, isError ?? false {
                errorView()
            }
            
            if let loadingView, isLoading ?? false {
                loadingView()
            }
        }
    }
}

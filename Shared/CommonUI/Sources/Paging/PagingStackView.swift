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
    Divider: View,
    ErrorView: View,
    LoadingView: View
>: View {
    
    // MARK: Lifecycle
    
    public init(
        items: [Item],
        isLoading: Bool?,
        isError: Bool?,
        stackType: PagingStackType,
        onAppearLast: @escaping () -> Void,
        content: @escaping (Item) -> Content,
        divider: (() -> Divider)?,
        errorView: (() -> ErrorView)?,
        loadingView: (() -> LoadingView)?
    ) {
        self.items = items
        self.isLoading = isLoading
        self.isError = isError
        self.stackType = stackType
        self.onAppearLast = onAppearLast
        self.content = content
        self.divider = divider
        self.errorView = errorView
        self.loadingView = loadingView
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
    private let onAppearLast: () -> Void
    private let content: (Item) -> Content
    private let divider: (() -> Divider)?
    private let errorView: (() -> ErrorView)?
    private let loadingView: (() -> LoadingView)?
}

private extension PagingStackView {
    @ViewBuilder
    func pagingContent() -> some View {
        ForEach(items) { item in
            content(item)
                .onAppear {
                    if items.last?.id == item.id {
                        onAppearLast()
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

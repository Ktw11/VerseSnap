//
//  PagingStackView.swift
//  CommonUI
//
//  Created by 공태웅 on 5/6/25.
//

import SwiftUI

public struct PagingStackView<
    Item: Identifiable,
    Content: View
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
        ScrollView(showsIndicators: false) {
            switch stackType {
            case .vStack:
                LazyVStack {
                    pagingContent()
                    errorContent()
                    loadingContent()
                }
            case .vGrid(let columns, let spacing):
                LazyVGrid(columns: columns, spacing: spacing) {
                    pagingContent()
                }
                
                errorContent()
                loadingContent()
            }
        }
    }
    
    private let items: [Item]
    private let isLoading: Bool?
    private let isError: Bool?
    private let stackType: PagingStackType
    private let content: (Item) -> Content
    
    private var onAppearLast: (() -> Void)?
    private var divider: (() -> AnyView)?
    private var errorView: (() -> AnyView)?
    private var loadingView: (() -> AnyView)?
}

public extension PagingStackView {
    func onAppearLast(_ action: @escaping () -> Void) -> Self {
        var view = self
        view.onAppearLast = action
        return view
    }
    
    func divider<DividerView: View>(@ViewBuilder _ divider: @escaping () -> DividerView) -> Self {
        var view = self
        view.divider = { AnyView(divider()) }
        return view
    }
    
    func errorView<ErrorView: View>(@ViewBuilder _ errorView: @escaping () -> ErrorView) -> Self {
        var view = self
        view.errorView = { AnyView(errorView()) }
        return view
    }
    
    func loadingView<LoadingView: View>(@ViewBuilder _ loadingView: @escaping () -> LoadingView) -> Self {
        var view = self
        view.loadingView = { AnyView(loadingView()) }
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
    }
    
    @ViewBuilder
    func errorContent() -> some View {
        if let errorView, isError ?? false {
            errorView()
        }
    }
    
    @ViewBuilder
    func loadingContent() -> some View {
        if let loadingView, isLoading ?? false {
            loadingView()
        }
    }
}

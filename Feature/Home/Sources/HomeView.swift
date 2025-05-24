//
//  HomeView.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI
import CommonUI
import NewVerseInterface

public struct HomeView<NewVerseComponent: NewVerseBuilder>: View {
    
    // MARK: Lifecycle
    
    public init(viewModel: HomeViewModel, newVerseBuilder: NewVerseComponent) {
        self.viewModel = viewModel
        self.newVerseBuilder = newVerseBuilder
    }
    
    // MARK: Properties
    
    @State private var isShowingPicker = false
    @Bindable private var viewModel: HomeViewModel
    @Namespace private var stackDiaryNamespace
    @Namespace private var gridDiaryNamespace
    private let newVerseBuilder: NewVerseComponent
    
    public var body: some View {
        NavigationStack {
            VStack {
                headerView()
                    .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 20)
                
                ZStack {
                    stackContentView()
                        .padding(.horizontal, 24)
                        .opacity(viewModel.displayStyle == .stack ? 1.0 : 0)
                    
                    gridContentView()
                        .padding(.horizontal, 5)
                        .opacity(viewModel.displayStyle == .grid ? 1.0 : 0)
                }
            }
            .foregroundStyle(.white)
            .padding(.top, 20)
            .toolbarVisibility(.hidden, for: .navigationBar)
            .background {
                CommonUIAsset.Color.mainBG.swiftUIColor
                    .padding(-50)
                    .ignoresSafeArea()
            }
        }
        .modalView($isShowingPicker) {
            YearMonthPickerView(
                selectedYear: $viewModel.selectedYear,
                selectedMonth: $viewModel.selectedMonth,
                isPresenting: $isShowingPicker,
                limit: viewModel.pickerLimit
            )
        }
        .fullScreenCover(item: Binding(
            get: { viewModel.presentingDetailViewModel },
            set: { viewModel.presentingDetailViewModel = $0 }
        )) { detailViewModel in
            detailDiaryView(detailViewModel)
        }
        .fullScreenCover(isPresented: $viewModel.isNewVersePresented) {
            newVerseBuilder.build(isPresented: $viewModel.isNewVersePresented)
                .presentationBackground(CommonUIAsset.Color.mainBG.swiftUIColor)
        }
        .onAppear {
            viewModel.fetchNextStackDiaries()
            viewModel.fetchNextGridDiaries()
        }
    }
}

private extension HomeView {
    @ViewBuilder
    func headerView() -> some View {
        VStack(spacing: 15) {
            ZStack {
                Group {
                    switch viewModel.displayStyle {
                    case .grid:
                        Text(verbatim: "Gallery")
                            .font(.suite(size: 18, weight: .regular))
                    case .stack:
                        HStack {
                            Text(viewModel.yearMonthString)
                                .font(.suite(size: 20, weight: .bold))
                            
                            HomeAsset.icDownArrow.swiftUIImage
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .onTapGesture {
                            isShowingPicker = true
                        }
                    }
                }
                
                viewModel.displayIcon
                    .resizable()
                    .frame(size: 24)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        viewModel.didTapDisplayIcon()
                    }
            }
            .padding(.bottom, 15)
        }
    }
    
    @ViewBuilder
    func stackContentView() -> some View {
        if viewModel.isStackDisplayLoading {
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else if viewModel.isStackDiaryEmpty {
            contentEmptyView()
        } else {
            PagingStackView(
                items: viewModel.stackViewModels,
                isLoading: viewModel.showLoadingStackView,
                isError: viewModel.isStackErrorOccured,
                stackType: .vStack,
                content: { stackContentItemView($0) }
            )
            .onAppearLast {
                viewModel.fetchNextStackDiaries()
            }
            .divider {
                Divider()
                    .frame(height: 1)
                    .overlay(CommonUIAsset.Color.placeholderBG.swiftUIColor)
            }
            .errorView {
                contentErrorView(action: { viewModel.fetchNextStackDiaries(byUser: true) } )
            }
            .loadingView { contentLoadingView() }
        }
    }
    
    @ViewBuilder
    func gridContentView() -> some View {
        if viewModel.isGridDisplayLoading {
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else if viewModel.isGridDiaryEmpty {
            contentEmptyView()
        } else {
            let columns: [GridItem] = Array(repeating: GridItem(spacing: 1), count: 3)

            PagingStackView(
                items: viewModel.gridViewModels,
                isLoading: viewModel.showLoadingGridView,
                isError: viewModel.isGridErrorOccured,
                stackType: .vGrid(columns: columns, spacing: 1),
                content: { gridContentItemView($0) }
            )
            .onAppearLast {
                viewModel.fetchNextGridDiaries()
            }
            .errorView {
                contentErrorView(action: { viewModel.fetchNextGridDiaries(byUser: true) } )
            }
            .loadingView { contentLoadingView() }
        }
    }
    
    @ViewBuilder
    func stackContentItemView(_ stackViewModel: HomeStackContentViewModel) -> some View {
        HomeStackContentView(viewModel: stackViewModel)
            .contentShape(Rectangle())
            .matchedTransitionSource(id: stackViewModel.id, in: stackDiaryNamespace)
            .onTapGesture {
                viewModel.didTapDiary(stackViewModel.id)
            }
            .frame(height: 84)
            .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func gridContentItemView(_ gridViewModel: HomeGridContentViewModel) -> some View {
        let icon = gridViewModel.isFavorite ? HomeAsset.icHeartFill.swiftUIImage : HomeAsset.icHeartEmpty.swiftUIImage
        
        Rectangle()
            .aspectRatio(3 / 4, contentMode: .fit)
            .overlay {
                if let imageURL = URL(string: gridViewModel.imageURL) {
                    CachedAsyncImage(url: imageURL)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                icon
                    .resizable()
                    .frame(size: 17)
                    .padding(.all, 5)
            }
            .clipped()
            .matchedTransitionSource(id: gridViewModel.id, in: gridDiaryNamespace)
            .onTapGesture {
                viewModel.didTapDiary(gridViewModel.id)
            }
    }
    
    @ViewBuilder
    func contentLoadingView() -> some View {
        LoadingView(size: 15)
            .padding(.vertical, 5)
            .frame(alignment: .center)
    }
    
    @ViewBuilder
    func contentErrorView(action: @escaping (() -> Void)) -> some View {
        RefreshButton(action: action)
            .padding(.top, 10)
    }
    
    @ViewBuilder
    func contentEmptyView() -> some View {
        Text("You haven’t created any verses yet.")
            .font(.suite(size: 14, weight: .regular))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func detailDiaryView(_ detailViewModel: DetailDiaryViewModel) -> some View {
        DetailDiaryView(
            viewModel: Binding(
                get: { detailViewModel },
                set: { viewModel.presentingDetailViewModel = $0 }
            )
        ) {
            viewModel.presentingDetailViewModel = nil
        } didTapFavorite: { newValue in
            viewModel.didTapFavorite(to: newValue, id: detailViewModel.id)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .switch(on: viewModel.displayStyle) { view, style in
            switch style {
            case .grid:
                view.navigationTransition(.zoom(sourceID: detailViewModel.id, in: gridDiaryNamespace))
            case .stack:
                view.navigationTransition(.zoom(sourceID: detailViewModel.id, in: stackDiaryNamespace))
            }
        }
    }
}

private struct RefreshButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            CommonUIAsset.Color.buttonBG.swiftUIColor
                .overlay(alignment: .center) {
                    HomeAsset.icRefresh.swiftUIImage
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .frame(size: 14)
                }
                .clipShape(Circle())
                .frame(size: 24)
                .frame(alignment: .center)
        })
    }
}

#if DEBUG
import PreviewSupport
#Preview {
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        HomeView(
            viewModel: HomeViewModel(
                calendar: Calendar.current,
                useCase: DiaryUseCasePreview.preview,
                diaryEventReceiver: DiaryEventReceiverPreview.preview,
                signUpDate: Date()
            ),
            newVerseBuilder: NewVersePreviewComponent()
        )
            .padding(.top, 22)
            .padding(.horizontal, 24)
    }
}
#endif

//
//  HomeView.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI
import CommonUI

public struct HomeView: View {
    
    // MARK: Lifecycle
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    
    @State private var isShowingPicker = false
    @State private var searchText: String = ""
    @Namespace private var namespace
    @Bindable private var viewModel: HomeViewModel
    
    public var body: some View {
        NavigationStack {
            ZStack {
                CommonUIAsset.Color.mainBG.swiftUIColor
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 15) {
                        ZStack {
                            HStack {
                                Text(viewModel.yearMonthString)
                                    .font(.suite(size: 20, weight: .bold))
                                
                                HomeAsset.icDownArrow.swiftUIImage
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                            .padding(.bottom, 15)
                            .opacity(viewModel.displayStyle == .stack ? 1.0 : 0)
                            .onTapGesture {
                                isShowingPicker = true
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
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    ZStack {
                        stackContentView()
                            .opacity(viewModel.displayStyle == .stack ? 1.0 : 0)
                        
                        gridContentView()
                            .opacity(viewModel.displayStyle == .grid ? 1.0 : 0)
                    }
                }
                .foregroundStyle(.white)
                .padding(.top, 20)
                .background(CommonUIAsset.Color.mainBG.swiftUIColor)
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
        .modalView($isShowingPicker) {
            YearMonthPickerView(
                selectedYear: $viewModel.selectedYear,
                selectedMonth: $viewModel.selectedMonth,
                isPresenting: $isShowingPicker,
                limit: viewModel.pickerLimit
            )
        }
        .onAppear {
            viewModel.fetchNextStackDiaries()
            viewModel.fetchNextGridDiaries()
        }
    }
}

private extension HomeView {
    @ViewBuilder
    func stackContentView() -> some View {
        if viewModel.isStackDisplayLoading {
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else if viewModel.isStackDiaryEmpty {
            contentEmotyView()
        } else {
            PagingStackView(
                items: viewModel.stackViewModels,
                isLoading: viewModel.showLoadingStackView,
                isError: viewModel.isStackErrorOccured,
                stackType: .vStack,
                content: { viewModel in
                    HomeStackContentView(viewModel: viewModel)
                        .frame(height: 84)
                        .padding(.vertical, 15)
                }
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
        if viewModel.isStackDisplayLoading {
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else if viewModel.isStackDiaryEmpty {
            contentEmotyView()
        } else {
            PagingStackView(
                items: viewModel.gridViewModels,
                isLoading: viewModel.showLoadingGridView,
                isError: viewModel.isGridErrorOccured,
                stackType: .vGrid(columns: Array(repeating: GridItem(spacing: 1), count: 3)),
                content: {
                    gridContentItemView($0)
                }
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
    func gridContentItemView(_ viewModel: HomeGridContentViewModel) -> some View {
        Rectangle()
            .aspectRatio(3 / 4, contentMode: .fit)
            .overlay {
                if let imageURL = URL(string: viewModel.imageURL) {
                    CachedAsyncImage(url: imageURL)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                viewModel.favoriteIcon
                    .resizable()
                    .frame(size: 17)
                    .padding(.all, 5)
            }
            .clipped()
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
    func contentEmotyView() -> some View {
        Text("아직 생성한 삼행시가 없습니다.")
            .font(.suite(size: 14, weight: .regular))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
                        .tint(Color.white)
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
        
        HomeView(viewModel: .init(calendar: Calendar.current, useCase: DiaryUseCasePreview.preview))
            .padding(.top, 22)
            .padding(.horizontal, 24)
    }
}
#endif

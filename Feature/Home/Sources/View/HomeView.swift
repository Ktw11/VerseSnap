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
    @Bindable private var viewModel: HomeViewModel
    
    public var body: some View {
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
                
                if viewModel.displayStyle == .grid {
                    searchBarView()
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
        .modalView($isShowingPicker) {
            YearMonthPickerView(
                selectedYear: $viewModel.selectedYear,
                selectedMonth: $viewModel.selectedMonth,
                isPresenting: $isShowingPicker,
                limit: viewModel.pickerLimit
            )
        }
        .onAppear {
            viewModel.fetchNextMonthlyDiaries()
        }
    }
    
    // MARK: Methods
    
    @ViewBuilder
    private func stackContentView() -> some View {
        if viewModel.showRowViewLoading {
            ZStack {
                LoadingView()
                    .frame(alignment: .center)
            }
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.rowViewModels, id: \.id) { rowVM in
                        HomeContentRowView(viewModel: rowVM)
                            .frame(height: 84)
                            .padding(.vertical, 15)
                            .onAppear {
                                if viewModel.rowViewModels.last == rowVM {
                                    viewModel.fetchNextMonthlyDiaries()
                                }
                            }
                        
                        if viewModel.rowViewModels.last != rowVM {
                            Divider()
                                .frame(height: 1)
                                .overlay(CommonUIAsset.Color.placeholderBG.swiftUIColor)
                        }
                    }
                    
                    if viewModel.isMonthlyErrorOccured {
                        RefreshButton() {
                            viewModel.fetchNextMonthlyDiaries()
                        }
                            .padding(.top, 10)
                    }
                    
                    if viewModel.showLoadingRowView {
                        LoadingView(size: 15)
                            .padding(.vertical, 5)
                            .frame(alignment: .center)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func gridContentView() -> some View {
        ScrollView {
            let columns: [GridItem] = Array(repeating: GridItem(spacing: 1), count: 3)
            
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(viewModel.gridViewModels, id: \.id) { gridVM in
                    Rectangle()
                        .aspectRatio(3 / 4, contentMode: .fit)
                        .overlay {
                            gridVM.image
                                .resizable()
                                .scaledToFill()
                        }
                        .overlay(alignment: .bottomTrailing) {
                            gridVM.favoriteIcon
                                .resizable()
                                .frame(size: 17)
                                .padding(.all, 5)
                        }
                        .clipped()
                }
            }
        }
    }
    
    #warning("구현 필요")
    @ViewBuilder
    private func searchBarView() -> some View {
        
        CommonUIAsset.Color.placeholderBG.swiftUIColor
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(height: 33)
            .overlay {
                HStack {
                    HomeAsset.icSearch.swiftUIImage
                        .resizable()
                        .frame(size: 17)
                    
                    TextField("", text: $searchText)
                        .autocorrectionDisabled(true)
                        .accentColor(Color.white)
                    
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(CommonUIAsset.Color.minorText.swiftUIColor)
                        .frame(size: 12)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
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

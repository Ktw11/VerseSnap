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
                            .font(.system(size: 24, weight: .bold))
                        
                        HomeAsset.icDownArrow.swiftUIImage
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
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
    }
    
    // MARK: Methods
    
    @ViewBuilder
    private func stackContentView() -> some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.rowViewModels, id: \.id) { rowVM in
                    HomeContentRowView(viewModel: rowVM)
                        .frame(height: 84)
                        .padding(.vertical, 15)
                    
                    if viewModel.rowViewModels.last != rowVM {
                        Divider()
                            .frame(height: 1)
                            .overlay(CommonUIAsset.Color.placeholderBG.swiftUIColor)
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

#Preview {
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        HomeView(viewModel: .init(calendar: Calendar.current))
            .padding(.top, 22)
            .padding(.horizontal, 24)
    }
}

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
    
    @State var isShowingPicker = false
    @Bindable private var viewModel: HomeViewModel
    
    public var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text(viewModel.yearMonthString)
                        .font(.system(size: 24, weight: .bold))
                    
                    HomeAsset.Image.icDownArrow.swiftUIImage
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .onTapGesture {
                    isShowingPicker = true
                }
                
                viewModel.displayIcon
                    .resizable()
                    .frame(size: 24)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Spacer()
                .frame(height: 40)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.rowViewModels, id: \.id) { rowVM in
                        HomeContentRowView(viewModel: rowVM)
                            .frame(height: 84)
                            .padding(.vertical, 15)
                        
                        if viewModel.rowViewModels.last != rowVM {
                            Divider()
                                .frame(height: 1)
                                .overlay(HomeAsset.Color.description.swiftUIColor)
                        }
                    }
                }
            }
            
            Spacer()
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
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        HomeView(viewModel: .init(calendar: Calendar.current))
            .padding(.top, 22)
            .padding(.horizontal, 24)
    }
}

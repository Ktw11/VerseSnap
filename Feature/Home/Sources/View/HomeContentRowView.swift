//
//  HomeContentRowView.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI
import CommonUI

struct HomeContentRowView: View {
    
    // MARK: Properties
    
    let viewModel: HomeContentRowViewModel
    
    var body: some View {
        HStack {
            PhotoContainerView(viewModel: viewModel.photoContainerViewModel)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Spacer().frame(width: 16)
            
            VStack {
                Text(viewModel.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 11, weight: .regular))
                
                Spacer().frame(height: 3)
                
                Text(viewModel.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12, weight: .regular))
                
                Spacer().frame(height: 15)
                
                if let timeString = viewModel.timeString {
                    Text(timeString)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(CommonUIAsset.Color.secondaryForeground.swiftUIColor)
                }
            }
            .padding(.vertical, 7)
            
            Spacer()
            
            viewModel.actionIcon
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

// MARK: SubViews

private struct PhotoContainerView: View {
    
    // MARK: Lifecycle
    
    init(viewModel: PhotoContainerViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    
    private let viewModel: PhotoContainerViewModel
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        image
                            .resizable()
                            .scaledToFill()
                        
                        Color.black.opacity(0.3)
                    }
                    .clipped()
            } else {
                Rectangle()
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        CommonUIAsset.Color.placeholder.swiftUIColor
                            .opacity(0.5)
                    }
                    .clipped()
            }
            
            VStack {
                if let title = viewModel.topTitle {
                    Text(title)
                        .font(.system(size: 25, weight: .regular))
                }
                
                Text(viewModel.bottomTitle)
                    .font(.system(size: 15, weight: .regular))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            HomeContentRowView(
                viewModel: .init(
                    id: "1",
                    photoContainerViewModel: .init(image: nil, topTitle: nil, bottomTitle: "Today"),
                    title: "오늘의 삼행시",
                    description: "기록하기",
                    timeString: nil,
                    actionIcon: CommonUIAsset.Image.icPlus.swiftUIImage
                )
            )
            .frame(height: 84)
            
            HomeContentRowView(
                viewModel: .init(
                    id: "2",
                    photoContainerViewModel: .init(image: nil, topTitle: "16", bottomTitle: "Mon"),
                    title: "6월 17일",
                    description: "삼/행/시",
                    timeString: "오후 12:30",
                    actionIcon: HomeAsset.icHeartFill.swiftUIImage
                )
            )
            .frame(height: 84)
            
            Spacer()
        }
        .foregroundStyle(.white)
    }
}

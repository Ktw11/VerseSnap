//
//  HomeStackContentView.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI
import CommonUI

struct HomeStackContentView: View {
    
    // MARK: Constants
    
    private enum Constants {
        static func actionIcon(isFavorite: Bool?) -> Image {
            guard let isFavorite else { return CommonUIAsset.Image.icPlus.swiftUIImage }
            return isFavorite ? HomeAsset.icHeartFill.swiftUIImage : HomeAsset.icHeartEmpty.swiftUIImage
        }
    }
    
    // MARK: Properties
    
    let viewModel: HomeStackContentViewModel
    
    var body: some View {
        HStack {
            PhotoContainerView(viewModel: viewModel.photoContainerViewModel)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Spacer().frame(width: 16)
            
            VStack {
                Text(viewModel.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.suite(size: 13, weight: .regular))
                
                Spacer().frame(height: 3)
                
                Text(viewModel.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.suite(size: 14, weight: .regular))
                
                Spacer().frame(height: 15)
                
                if let timeString = viewModel.timeString {
                    Text(timeString)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.suite(size: 12, weight: .regular))
                        .foregroundStyle(CommonUIAsset.Color.minorText.swiftUIColor)
                }
            }
            .padding(.vertical, 7)
            
            Spacer()
            
            Constants.actionIcon(isFavorite: viewModel.isFavorite)
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
            if let imageURL = URL(string: viewModel.imageURL) {
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        CachedAsyncImage(url: imageURL)
                        
                        Color.black.opacity(0.3)
                    }
                    .clipped()
            } else {
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        CommonUIAsset.Color.placeholderBG.swiftUIColor
                    }
                    .clipped()
            }
            
            VStack {
                if let title = viewModel.topTitle {
                    Text(title)
                        .font(.urbanist(size: 25, weight: .semibold))
                }
                
                Text(viewModel.bottomTitle)
                    .font(.urbanist(size: 15, weight: .medium))
            }
        }
    }
}

#Preview {
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        VStack(spacing: 20) {
            HomeStackContentView(
                viewModel: .init(
                    id: "1",
                    photoContainerViewModel: .init(imageURL: "", topTitle: nil, bottomTitle: "Today"),
                    title: "오늘의 삼행시",
                    description: "기록하기",
                    timeString: nil,
                    isFavorite: nil
                )
            )
            .frame(height: 84)
            
            HomeStackContentView(
                viewModel: .init(
                    id: "2",
                    photoContainerViewModel: .init(imageURL: "https://randomuser.me/api/portraits/men/50.jpg", topTitle: "16", bottomTitle: "Mon"),
                    title: "6월 17일",
                    description: "삼/행/시",
                    timeString: "오후 12:30",
                    isFavorite: true
                )
            )
            .frame(height: 84)
            
            Spacer()
        }
        .foregroundStyle(.white)
    }
}

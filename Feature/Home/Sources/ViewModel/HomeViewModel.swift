//
//  HomeViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI

@Observable
@MainActor
public final class HomeViewModel {
    
    // MARK: Lifecycle
    
    init() {
        let diaries: [Diary] = [
            .init(
                photo: HomeAsset.Image.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: false,
                firstCharacters: "삼/행/시"
            ),
            .init(
                photo: HomeAsset.Image.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: true,
                firstCharacters: "삼/행/시"
            ),
            .init(
                photo: HomeAsset.Image.testImage.swiftUIImage,
                createdAt: Date(),
                isFavorite: false,
                firstCharacters: "사/행/시/시"
            )
        ]
        
        var result: [HomeContentRowViewModel] = []
        
        result.append(
            .init(
                id: "1",
                photoContainerViewModel: .init(
                    image: nil,
                    topTitle: nil,
                    bottomTitle: "Today"
                ),
                title: "오늘의 삼행시",
                description: "기록하기",
                timeString: nil,
                actionIcon: HomeAsset.Image.icPlus.swiftUIImage
            )
        )
        result.append(
            .init(
                id: "2",
                photoContainerViewModel: .init(
                    image: HomeAsset.Image.testImage.swiftUIImage,
                    topTitle: nil,
                    bottomTitle: "Today"
                ),
                title: "오늘",
                description: "삼/행/시",
                timeString: nil,
                actionIcon: HomeAsset.Image.icHeartEmpty.swiftUIImage
            )
        )
        
        result.append(contentsOf: diaries.map(\.toViewModel))
        
        self.rowViewModels = result
    }
    
    // MARK: Properties
    
    let yearMonthString: String = "2025.6"
    var displayIcon: Image {
        if true { HomeAsset.Image.icGridDisplay.swiftUIImage } else { HomeAsset.Image.icStackDisplay.swiftUIImage }
    }
    let rowViewModels: [HomeContentRowViewModel]
}

#warning("임시 구조체 - 제거 필요")
struct Diary: Equatable {
    let id: UUID = .init()
    let photo: Image
    let createdAt: Date
    let isFavorite: Bool
    let firstCharacters: String
}

extension Diary {
    var toViewModel: HomeContentRowViewModel {
        .init(
            id: id.uuidString,
            photoContainerViewModel: .init(
                image: photo,
                topTitle: "16",
                bottomTitle: "Mon"
            ),
            title: "6월 17일",
            description: firstCharacters,
            timeString: "오후 12:30",
            actionIcon: isFavorite ? HomeAsset.Image.icHeartFill.swiftUIImage : HomeAsset.Image.icHeartEmpty.swiftUIImage
        )
    }
}

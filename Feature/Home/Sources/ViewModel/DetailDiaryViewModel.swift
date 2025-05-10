//
//  DetailDiaryViewModel.swift
//  Home
//
//  Created by 공태웅 on 5/9/25.
//

import Foundation
import Domain
import CommonUI
import Utils

@Observable
@MainActor
final class DetailDiaryViewModel: Identifiable {
    
    // MARK: Lifecycle
    
    init(from diary: VerseDiary, imageRatio: CGFloat = 0.65) {
        let createdDate: Date = Date(timeIntervalSince1970: diary.createdAt)
        
        self.id = diary.id
        self.dateString = createdDate.yearMonthDayString()
        self.timeString = createdDate.timeString()
        self.imageRatio = imageRatio
        self.imageURL = diary.imageURL
        self.verse = diary.verse
            .highlightFirstCharacterOfEachLine(
                highlightedFont: .suite(size: 14, weight: .bold),
                regularFont: .suite(size: 14, weight: .regular)
            )
        self.hashtags = diary.hashtags.map { Hashtag(value: $0) }
        self.isFavorte = diary.isFavorite
    }
    
    // MARK: Properties
    
    let id: String
    let dateString: String
    let timeString: String
    let imageRatio: CGFloat
    let imageURL: String
    let verse: AttributedString?
    let hashtags: [Hashtag]
    var isFavorte: Bool
}

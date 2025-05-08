//
//  HomeStackViewModelFactory.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI
import Domain

struct HomeStackViewModelFactory: HomeContentViewModelFactory {
    
    // MARK: Properties
    
    let calendar: Calendar
    let favoriteIcon: Image
    let normalIcon: Image
    
    // MARK: Definitions
    
    private enum Constants {
        static let weekdaySymbols: [String] = [
            "mon", "tue", "wed", "thu", "fri", "sat", "sun"
        ]
    }
    
    // MARK: Methods
    
    func build(from diary: VerseDiary) -> HomeStackContentViewModel {
        let createdDate: Date = Date(timeIntervalSince1970: diary.createdAt)
        let day: Int = calendar.component(.day, from: createdDate)
        let weekdayIndex: Int = calendar.component(.weekday, from: createdDate)
        
        return HomeStackContentViewModel(
            id: diary.id,
            photoContainerViewModel: .init(
                imageURL: diary.imageURL,
                topTitle: String(day),
                bottomTitle: Constants.weekdaySymbols[safe: weekdayIndex] ?? ""
            ),
            title: createdDate.monthDayString(),
            description: diary.verse.firstLetters(separator: "/"),
            timeString: createdDate.timeString(),
            actionIcon: diary.isFavorite ? favoriteIcon : normalIcon
        )
    }
}

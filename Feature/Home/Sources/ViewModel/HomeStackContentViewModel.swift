//
//  HomeStackContentViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI

@Observable
@MainActor
final class HomeStackContentViewModel: Identifiable {
    
    // MARK: Lifecycle
    
    init(id: String, photoContainerViewModel: PhotoContainerViewModel, title: String, description: String, timeString: String?, isFavorite: Bool? = nil) {
        self.id = id
        self.photoContainerViewModel = photoContainerViewModel
        self.title = title
        self.description = description
        self.timeString = timeString
        self.isFavorite = isFavorite
    }

    // MARK: Definitions
    
    enum Constants {
        static let weekdaySymbols: [String] = [
            "mon", "tue", "wed", "thu", "fri", "sat", "sun"
        ]
        static let placeholderId: String = "__PLACEHOLDER__"
    }
    
    // MARK: Properties
    
    let id: String
    let photoContainerViewModel: PhotoContainerViewModel
    let title: String
    let description: String
    let timeString: String?
    var isFavorite: Bool?
}

extension HomeStackContentViewModel: HomeContentViewModel {
    func setFavorite(to isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

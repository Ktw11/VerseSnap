//
//  HomeStackContentViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI

struct HomeStackContentViewModel: Equatable, Identifiable {

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
    let actionIcon: Image
}

extension HomeStackContentViewModel: HomeContentViewModel { }

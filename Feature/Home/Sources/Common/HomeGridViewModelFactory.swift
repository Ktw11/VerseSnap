//
//  HomeGridViewModelFactory.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI
import Domain

struct HomeGridViewModelFactory: HomeContentViewModelFactory {
    
    // MARK: Methods
    
    func build(from diary: VerseDiary) -> HomeGridContentViewModel {
        HomeGridContentViewModel(
            id: diary.id,
            imageURL: diary.imageURL,
            isFavorite: diary.isFavorite
        )
    }
}

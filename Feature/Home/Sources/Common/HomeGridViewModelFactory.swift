//
//  HomeGridViewModelFactory.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI
import Domain

struct HomeGridViewModelFactory: HomeContentViewModelFactory {
    
    // MARK: Properties
    
    let favoriteIcon: Image
    let normalIcon: Image
    
    // MARK: Methods
    
    func build(from diary: VerseDiary) -> HomeGridContentViewModel {
        HomeGridContentViewModel(
            id: diary.id,
            imageURL: diary.imageURL,
            favoriteIcon: diary.isFavorite ? favoriteIcon : normalIcon
        )
    }
}

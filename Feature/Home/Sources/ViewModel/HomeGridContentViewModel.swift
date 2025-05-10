//
//  HomeGridContentViewModel.swift
//  Home
//
//  Created by 공태웅 on 5/7/25.
//

import SwiftUI

@Observable
@MainActor
final class HomeGridContentViewModel: Identifiable {
    
    // MARK: Lifecycle
    
    init(id: String, imageURL: String, isFavorite: Bool) {
        self.id = id
        self.imageURL = imageURL
        self.isFavorite = isFavorite
    }
    
    // MARK: Properties
    
    let id: String
    let imageURL: String
    var isFavorite: Bool
}

extension HomeGridContentViewModel: HomeContentViewModel {
    func setFavorite(to isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}

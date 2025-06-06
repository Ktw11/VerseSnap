//
//  HomeContentViewModel.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import Foundation
import Domain

protocol HomeContentViewModel: Identifiable, Sendable {
    var id: String { get }
    
    @MainActor func setFavorite(to isFavorite: Bool)
}

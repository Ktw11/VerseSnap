//
//  HomeContentRowViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI

struct HomeContentRowViewModel: Equatable, Identifiable {
    let id: String
    let photoContainerViewModel: PhotoContainerViewModel
    let title: String
    let description: String
    let timeString: String?
    let actionIcon: Image
}

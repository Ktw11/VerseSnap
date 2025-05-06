//
//  PhotoContainerViewModel.swift
//  Home
//
//  Created by 공태웅 on 3/9/25.
//

import SwiftUI

struct PhotoContainerViewModel: Equatable, Sendable {
    let imageURL: String
    let topTitle: String?
    let bottomTitle: LocalizedStringResource
}

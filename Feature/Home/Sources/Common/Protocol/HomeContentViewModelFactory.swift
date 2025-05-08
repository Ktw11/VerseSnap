//
//  HomeContentViewModelFactory.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import Foundation
import Domain

protocol HomeContentViewModelFactory<ViewModel>: Sendable {
    associatedtype ViewModel: HomeContentViewModel

    func build(from diary: VerseDiary) -> ViewModel
}

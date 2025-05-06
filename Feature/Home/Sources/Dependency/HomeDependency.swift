//
//  HomeDependency.swift
//  Home
//
//  Created by 공태웅 on 3/11/25.
//

import Foundation
import Domain

public struct HomeDependency {
    
    // MARK: Lifecycle
    
    public init(
        useCase: DiaryUseCase
    ) {
        self.useCase = useCase
    }
    
    // MARK: Properties

    let useCase: DiaryUseCase
}

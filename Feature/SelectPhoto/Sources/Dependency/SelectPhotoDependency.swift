//
//  SelectPhotoDependency.swift
//  SelectPhotoInterface
//
//  Created by 공태웅 on 4/12/25.
//

import Foundation
import Domain

public struct SelectPhotoDependency {
    
    // MARK: Lifecycle
    
    public init(
        pageSize: Int = 30,
        useCase: FetchPhotoAssetUseCase,
    ) {
        self.pageSize = pageSize
        self.useCase = useCase
    }
    
    // MARK: Properties
    
    let pageSize: Int
    let useCase: FetchPhotoAssetUseCase
}

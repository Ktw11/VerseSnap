//
//  NewVerseDependency.swift
//  NewVerse
//
//  Created by 공태웅 on 4/20/25.
//

import Foundation
import SelectPhotoInterface
import Domain

public struct NewVerseDependency<SelectPhotoComponent: SelectPhotoBuilder> {
    
    // MARK: Lifecycle
    
    public init(
        useCase: VerseUseCase,
        selectPhotoBuilder: SelectPhotoComponent,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.selectPhotoBuilder = selectPhotoBuilder
        self.useCase = useCase
        self.appStateUpdator = appStateUpdator
    }
    
    // MARK: Properties

    let selectPhotoBuilder: SelectPhotoComponent
    let useCase: VerseUseCase
    let appStateUpdator: GlobalAppStateUpdatable
}

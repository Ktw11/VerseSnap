//
//  NewDiaryDependency.swift
//  NewDiary
//
//  Created by 공태웅 on 4/20/25.
//

import Foundation
import SelectPhotoInterface
import Domain

public struct NewDiaryDependency<SelectPhotoComponent: SelectPhotoBuilder> {
    
    // MARK: Lifecycle
    
    public init(
        useCase: VerseUseCase,
        selectPhotoBuilder: SelectPhotoComponent
    ) {
        self.selectPhotoBuilder = selectPhotoBuilder
        self.useCase = useCase
    }
    
    // MARK: Properties

    let selectPhotoBuilder: SelectPhotoComponent
    let useCase: VerseUseCase
}

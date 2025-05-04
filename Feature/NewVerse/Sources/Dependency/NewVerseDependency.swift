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
        verseUseCase: VerseUseCase,
        diaryUseCase: DiaryUseCase,
        selectPhotoBuilder: SelectPhotoComponent,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.selectPhotoBuilder = selectPhotoBuilder
        self.verseUseCase = verseUseCase
        self.diaryUseCase = diaryUseCase
        self.appStateUpdator = appStateUpdator
    }
    
    // MARK: Properties

    let selectPhotoBuilder: SelectPhotoComponent
    let verseUseCase: VerseUseCase
    let diaryUseCase: DiaryUseCase
    let appStateUpdator: GlobalAppStateUpdatable
}

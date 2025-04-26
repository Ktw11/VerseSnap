//
//  DependencyContainer+NewDiary.swift
//  App
//
//  Created by 공태웅 on 4/20/25.
//

import SwiftUI
import NewDiary
import NewDiaryInterface
import Domain

extension DependencyContainer {
    @MainActor
    var newDiaryBuilder: some NewDiaryBuilder {
        NewDiaryComponent(
            dependency: NewDiaryDependency(
                useCase: useCaseBuilder.verseUseCase,
                selectPhotoBuilder: selectPhotoBuilder
            )
        )
    }
}

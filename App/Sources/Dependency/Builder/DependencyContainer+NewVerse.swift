//
//  DependencyContainer+NewVerse.swift
//  App
//
//  Created by 공태웅 on 4/20/25.
//

import SwiftUI
import NewVerse
import NewVerseInterface
import Domain

extension DependencyContainer {
    @MainActor
    var newVerseBuilder: some NewVerseBuilder {
        NewVerseComponent(
            dependency: NewVerseDependency(
                useCase: useCaseBuilder.verseUseCase,
                selectPhotoBuilder: selectPhotoBuilder,
                appStateUpdator: appStateStore
            )
        )
    }
}

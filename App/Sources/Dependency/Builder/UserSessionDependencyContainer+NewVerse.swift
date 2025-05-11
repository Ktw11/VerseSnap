//
//  UserSessionDependencyContainer+NewVerse.swift
//  App
//
//  Created by 공태웅 on 4/20/25.
//

import SwiftUI
import NewVerse
import NewVerseInterface
import Domain

extension UserSessionDependencyContainer {
    @MainActor
    var newVerseBuilder: some NewVerseBuilder {
        NewVerseComponent(
            dependency: NewVerseDependency(
                verseUseCase: useCaseBuilder.verseUseCase,
                diaryUseCase: useCaseBuilder.diaryUseCase,
                selectPhotoBuilder: selectPhotoBuilder,
                appStateUpdator: appStateStore,
            )
        )
    }
}

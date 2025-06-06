//
//  UserSessionDependencyContainer+Home.swift
//  App
//
//  Created by 공태웅 on 3/11/25.
//

import Foundation
import Home
import HomeInterface

extension UserSessionDependencyContainer {
    @MainActor
    var homeBuilder: some HomeBuilder {
        HomeComponent(
            user: user,
            calendar: Calendar(identifier: .gregorian),
            dependency: HomeDependency(
                useCase: useCaseBuilder.diaryUseCase,
                newVerseBuilder: newVerseBuilder,
                diaryEventReceiver: diaryEventReceiver
            )
        )
    }
}

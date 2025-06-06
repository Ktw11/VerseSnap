//
//  HomeDependency.swift
//  Home
//
//  Created by 공태웅 on 3/11/25.
//

import Foundation
import NewVerseInterface
import Domain

public struct HomeDependency<NewVerseComponent: NewVerseBuilder> {
    
    // MARK: Lifecycle
    
    public init(
        useCase: DiaryUseCase,
        newVerseBuilder: NewVerseComponent,
        diaryEventReceiver: DiaryEventReceiver
    ) {
        self.useCase = useCase
        self.newVerseBuilder = newVerseBuilder
        self.diaryEventReceiver = diaryEventReceiver
    }
    
    // MARK: Properties

    let useCase: DiaryUseCase
    let newVerseBuilder: NewVerseComponent
    let diaryEventReceiver: DiaryEventReceiver
}

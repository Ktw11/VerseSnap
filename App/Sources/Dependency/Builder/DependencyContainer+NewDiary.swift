//
//  DependencyContainer+NewDiary.swift
//  App
//
//  Created by 공태웅 on 4/20/25.
//

import SwiftUI
import NewDiary
import NewDiaryInterface

extension DependencyContainer {
    @MainActor
    var newDiaryBuilder: some NewDiaryBuilder {
        NewDiaryComponent(
            dependency: NewDiaryDependency(
                selectPhotoBuilder: selectPhotoBuilder
            )
        )
    }
}

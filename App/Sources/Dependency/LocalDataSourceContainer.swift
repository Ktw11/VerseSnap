//
//  LocalDataSourceContainer.swift
//  App
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation
import SwiftData
import Repository

struct LocalDataSourceContainer {
    
    // MARK: Lifecycle
    
    init(container: ModelContainer) {
        self.signInInfoDataSource = SignInInfoLocalDataSource(container: container)
        self.diaryLocalDataSource = DiaryLocalDataSourceImpl(container: container)
    }
    
    // MARK: Properties
    
    let signInInfoDataSource: SignInInfoDataSource
    let diaryLocalDataSource: DiaryLocalDataSource
}

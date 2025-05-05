//
//  RepositoryBuilder.swift
//  App
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import SwiftData
import Domain
import Repository
import VSNetwork

protocol RepositoryBuilder {
    var authRepository: AuthRepository { get }
    var signInInfoRepository: SignInInfoRepository { get }
    var verseRepository: VerseRepository { get }
    var diaryRepository: DiaryRepository { get }
}

final class RepositoryComponent: RepositoryBuilder {

    // MARK: Lifecycle
    
    init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: Properties
    
    private let networkProvider: NetworkProvidable
    
    private lazy var modelContainer: ModelContainer = {
        let schema = Schema([
            PermanentDiary.self,
            PermanentSignInInfo.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    private lazy var signInInfoDataSource: SignInInfoDataSource = {
        SignInInfoLocalDataSource(container: modelContainer)
    }()
    private lazy var diaryLocalDataSource: DiaryLocalDataSource = {
        DiaryLocalDataSourceImpl(container: modelContainer)
    }()
    
    var authRepository: AuthRepository {
        AuthRepositoryImpl(networkProvider: networkProvider)
    }
    
    var signInInfoRepository: SignInInfoRepository {
        SignInInfoRepositoryImpl(dataSource: signInInfoDataSource)
    }
    
    var verseRepository: VerseRepository {
        VerseRepositoryImpl(networkProvider: networkProvider)
    }
    
    var diaryRepository: DiaryRepository {
        DiaryRepositoryImpl(
            networkProvider: networkProvider,
            localDataSource: diaryLocalDataSource
        )
    }
}

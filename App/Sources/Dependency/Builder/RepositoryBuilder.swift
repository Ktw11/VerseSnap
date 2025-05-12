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

protocol RepositoryBuilder: Sendable {
    var verseRepository: VerseRepository { get }
    var diaryRepository: DiaryRepository { get }
    var userRepository: UserRepository { get }
}

final class RepositoryComponent: RepositoryBuilder {

    // MARK: Lifecycle
    
    init(
        userId: String,
        networkProvider: NetworkProvidable,
        localDataSouceContainer: LocalDataSourceContainer
    ) {
        self.userId = userId
        self.networkProvider = networkProvider
        self.localDataSouceContainer = localDataSouceContainer
    }
    
    // MARK: Properties

    private let userId: String
    private let networkProvider: NetworkProvidable
    private let localDataSouceContainer: LocalDataSourceContainer
    
    var verseRepository: VerseRepository {
        VerseRepositoryImpl(networkProvider: networkProvider)
    }
    
    var diaryRepository: DiaryRepository {
        DiaryRepositoryImpl(
            userId: userId,
            networkProvider: networkProvider,
            localDataSource: localDataSouceContainer.diaryLocalDataSource
        )
    }
    
    var userRepository: UserRepository {
        UserRepositoryImpl(networkProvider: networkProvider)
    }
}

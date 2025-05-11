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
}

final class RepositoryComponent: RepositoryBuilder {

    // MARK: Lifecycle
    
    init(
        networkProvider: NetworkProvidable,
        localDataSouceContainer: LocalDataSourceContainer
    ) {
        self.networkProvider = networkProvider
        self.localDataSouceContainer = localDataSouceContainer
    }
    
    // MARK: Properties

    private let networkProvider: NetworkProvidable
    private let localDataSouceContainer: LocalDataSourceContainer
    
    var verseRepository: VerseRepository {
        VerseRepositoryImpl(networkProvider: networkProvider)
    }
    
    var diaryRepository: DiaryRepository {
        DiaryRepositoryImpl(
            networkProvider: networkProvider,
            localDataSource: localDataSouceContainer.diaryLocalDataSource
        )
    }
}

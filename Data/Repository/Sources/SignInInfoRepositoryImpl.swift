//
//  SignInInfoRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

actor SignInInfoRepositoryImpl: SignInInfoRepository {

    // MARK: Lifecycle
    
    init(dataSource: SignInInfoDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: Properties
    
    private let dataSource: SignInInfoDataSource
    
    // MARK: Methods
    
    func retrieve() async -> SignInInfo? {
        await dataSource.retrieve()?.toDomain
    }
    
    func save(info: SignInInfo) async throws {
        let dto = SignInInfoDTO(refreshToken: info.refreshToken, signInType: info.signInType)
        try await dataSource.save(info: dto)
    }
    
    func reset() async throws {
        try await dataSource.reset()
    }
}

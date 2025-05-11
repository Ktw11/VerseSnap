//
//  SignInInfoRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import Domain

public actor SignInInfoRepositoryImpl: SignInInfoRepository {

    // MARK: Lifecycle
    
    public init(dataSource: SignInInfoDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: Properties
    
    private let dataSource: SignInInfoDataSource
    
    // MARK: Methods
    
    public func retrieve() async -> SignInInfo? {
        await dataSource.retrieve()?.toDomain
    }
    
    public func save(info: SignInInfo) async throws {
        let dto = SignInInfoDTO(refreshToken: info.refreshToken, signInType: info.signInType, userId: info.userId)
        try await dataSource.save(info: dto)
    }
    
    public func reset() async throws {
        try await dataSource.reset()
    }
}

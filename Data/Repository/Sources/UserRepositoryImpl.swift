//
//  UserRepositoryImpl.swift
//  Repository
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation
import VSNetwork
import Domain

public actor UserRepositoryImpl: UserRepository {
    
    // MARK: Lifecycle
    
    public init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: Properties

    private let networkProvider: NetworkProvidable
    
    // MARK: Methods
    
    public func updateNickname(to nickname: String) async throws {
        let api: API = UserAPI.changeNickname(nickname)
        
        do {
            _ = try await networkProvider.request(api: api)
        } catch {
            throw DomainError.unknown
        }
    }
}

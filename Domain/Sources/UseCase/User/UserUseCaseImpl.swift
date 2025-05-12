//
//  UserUseCaseImpl.swift
//  Domain
//
//  Created by 공태웅 on 5/11/25.
//

import Foundation

public actor UserUseCaseImpl: UserUseCase {
    
    // MARK: Lifecycle

    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    // MARK: Properties
    
    private let repository: UserRepository
    
    // MARK: Methods
    
    public func updateNickname(to nickname: String) async throws {        
        try await repository.updateNickname(to: nickname)
    }
}

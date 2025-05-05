//
//  SignInInfoLocalDataSource.swift
//  Repository
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import SwiftData

public protocol SignInInfoDataSource: Sendable {
    func retrieve() async -> SignInInfoDTO?
    func save(info: SignInInfoDTO) async throws
    func reset() async throws
}

@ModelActor
public actor SignInInfoLocalDataSource: SignInInfoDataSource {
    
    // MARK: Lifecycle
    
    public init(container: ModelContainer) {
        self.modelContainer = container
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(container))
    }
    
    // MARK: Methods
    
    public func retrieve() -> SignInInfoDTO? {
        let descriptor = FetchDescriptor<PermanentSignInInfo>()
        return try? modelContext.fetch(descriptor).first?.toDTO
    }

    public func save(info: SignInInfoDTO) throws {
        try reset()
        modelContext.insert(info.toPermanent)
        try modelContext.save()
    }
    
    public func reset() throws {
        try modelContext.delete(model: PermanentSignInInfo.self)
    }
}

private extension PermanentSignInInfo {
    var toDTO: SignInInfoDTO {
        .init(refreshToken: refreshToken, signInType: signInType)
    }
}

private extension SignInInfoDTO {
    var toPermanent: PermanentSignInInfo {
        .init(refreshToken: refreshToken, signInType: signInType)
    }
}

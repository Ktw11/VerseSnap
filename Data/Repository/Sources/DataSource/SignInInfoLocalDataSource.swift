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
    
    public init() {
        let schema = Schema([
            PermanentSignInInfo.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let modelContext = ModelContext(container)
            self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
            self.modelContainer = container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
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

@Model
private final class PermanentSignInInfo {
    @Attribute(.unique)
    @Attribute(.allowsCloudEncryption)
    var refreshToken: String
    var signInType: String
    
    init(refreshToken: String, signInType: String) {
        self.refreshToken = refreshToken
        self.signInType = signInType
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

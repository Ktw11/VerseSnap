//
//  NetworkProvider.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public actor NetworkProvider: NetworkProvidable {
    
    // MARK: Lifecycle
    
    public init(
        session: URLSession = .shared,
        configuration: NetworkConfigurable
    ) {
        self.session = session
        self.configuration = configuration
    }
    
    // MARK: Properties
    
    private(set) weak var tokenStore: TokenStorable?
    private(set) weak var tokenRefresher: TokenRefreshable?
    private let configuration: NetworkConfigurable
    private let session: URLSession
    
    // MARK: Methods
    
    public func request(api: API) async throws -> Data {
        try await requestData(api: api, retry: true)
    }
    
    public func setTokenStore(_ store: TokenStorable) {
        self.tokenStore = store
    }
    
    public func setTokenRefresher(_ refresher: TokenRefreshable) {
        self.tokenRefresher = refresher
    }
}

private extension NetworkProvider {
    func requestData(api: API, retry: Bool = true) async throws -> Data {
        let accessToken = await tokenStore?.accessToken
        let request: URLRequest = try api.makeURLRequest(baseURLString: configuration.baseUrlString, accessToken: accessToken)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            if httpResponse.statusCode == 401 && retry, let tokenRefresher {
                try await tokenRefresher.refreshTokens()
                
                return try await requestData(api: api, retry: false)
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                throw NetworkError.authenticationFailed
            case 400...499:
                throw NetworkError.badRequest(code: httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknown
            }
        } catch {
            throw NetworkError.failedInGeneral(error)
        }
    }
}

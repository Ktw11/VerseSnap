//
//  NetworkError.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case failedInGeneral(Error)
    case authenticationFailed
    case badRequest(code: Int)
    case invalidResponse
    case serverError
    case unknown
}

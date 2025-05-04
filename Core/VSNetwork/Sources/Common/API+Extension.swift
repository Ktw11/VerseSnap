//
//  API+Extension.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

extension API {
    func makeURLRequest(baseURLString: String, accessToken: String?) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            throw NetworkError.invalidURL
        }
        
        if let queryParameters {
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url?.appendingPathComponent(path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch contentType {
        case .json:
            if let bodyParameters {
                request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case let .multipart(files):
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let form = MultipartFormData(
                files: files,
                parameters: bodyParameters?.compactMapValues { "\($0)" } ?? [:]
            )
            request.httpBody = makeMultipartBody(form, boundary: boundary)
        }
        
        headers.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        
        if let accessToken, needsAuthorization {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}

private extension API {
    func makeMultipartBody(_ form: MultipartFormData, boundary: String) -> Data {
        var body = Data()
        for (key, value) in form.parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)  ?? Data())
            body.append("\(value)\r\n".data(using: .utf8) ?? Data())
        }
        for file in form.files {
            body.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n".data(using: .utf8) ?? Data())
            body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8) ?? Data())
            body.append(file.data)
            body.append("\r\n".data(using: .utf8) ?? Data())
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        return body
    }
}

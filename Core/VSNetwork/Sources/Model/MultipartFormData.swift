//
//  MultipartFormData.swift
//  VSNetwork
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation

public struct MultipartFormData {
    public struct MultipartFile {
        public init(data: Data, name: String, fileName: String, mimeType: String) {
            self.data = data
            self.name = name
            self.fileName = fileName
            self.mimeType = mimeType
        }
        
        public let data: Data
        public let name: String
        public let fileName: String
        public let mimeType: String
    }
    
    public init(files: [MultipartFile], parameters: [String : String]) {
        self.files = files
        self.parameters = parameters
    }
    
    public let files: [MultipartFile]
    public let parameters: [String: String]
}

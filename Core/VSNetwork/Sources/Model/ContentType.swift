//
//  ContentType.swift
//  VSNetwork
//
//  Created by 공태웅 on 4/27/25.
//

import Foundation

public enum ContentType {
    case json
    case multipart([MultipartFormData.MultipartFile])
}

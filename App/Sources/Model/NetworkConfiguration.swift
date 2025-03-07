//
//  NetworkConfiguration.swift
//  App
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation
import VSNetwork

struct NetworkConfiguration: NetworkConfigurable, Sendable {
    
    // MARK: Lifecycle
    
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }

    // MARK: Properties
    
    let baseUrlString: String
}

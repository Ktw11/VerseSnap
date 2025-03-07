//
//  NetworkConfigurable.swift
//  Network
//
//  Created by 공태웅 on 3/2/25.
//

import Foundation

public protocol NetworkConfigurable: Sendable {
    var baseUrlString: String { get }
}

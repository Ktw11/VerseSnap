//
//  HomeBuilder.swift
//  HomeInterface
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI

public protocol HomeBuilder {
    associatedtype SomeView: View
    
    @MainActor
    @ViewBuilder
    func build() -> SomeView
}

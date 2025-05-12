//
//  ProfileBuilder.swift
//  Profile
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI

public protocol ProfileBuilder {
    associatedtype SomeView: View
    
    @MainActor
    @ViewBuilder
    func build() -> SomeView
}

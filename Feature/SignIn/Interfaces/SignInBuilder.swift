//
//  SignInBuilder.swift
//  SignIn
//
//  Created by 공태웅 on 2/23/25.
//

import SwiftUI

public protocol SignInBuilder {
    associatedtype SomeView: View
    
    @MainActor
    @ViewBuilder
    func build() -> SomeView
}

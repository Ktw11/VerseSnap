//
//  NewDiaryBuilder.swift
//  NewDiary
//
//  Created by 공태웅 on 4/20/25.
//

import SwiftUI

public protocol NewDiaryBuilder {
    associatedtype SomeView: View
    
    @MainActor
    @ViewBuilder
    func build(isPresented: Binding<Bool>) -> SomeView
}

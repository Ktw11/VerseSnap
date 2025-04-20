//
//  NewDiaryComponent.swift
//  NewDiary
//
//  Created by 공태웅 on 3/18/25.
//

import SwiftUI
import NewDiaryInterface

public final class NewDiaryComponent: NewDiaryBuilder {
    
    // MARK: Lifecycle
    
    public init() { }
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(isPresented: Binding<Bool>) -> NewDiaryView {
        NewDiaryView(isPresented: isPresented, viewModel: NewDiaryViewModel())
    }
}

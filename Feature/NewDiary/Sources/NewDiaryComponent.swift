//
//  NewDiaryComponent.swift
//  NewDiary
//
//  Created by 공태웅 on 3/18/25.
//

import SwiftUI
import NewDiaryInterface
import SelectPhotoInterface

public final class NewDiaryComponent<SelectPhotoComponent: SelectPhotoBuilder>: NewDiaryBuilder {
    
    // MARK: Lifecycle
    
    public init(dependency: NewDiaryDependency<SelectPhotoComponent>) {
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let dependency: NewDiaryDependency<SelectPhotoComponent>
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(isPresented: Binding<Bool>) -> some View {
        NewDiaryView(
            isPresented: isPresented,
            viewModel: NewDiaryViewModel(),
            selectPhotoBuilder: dependency.selectPhotoBuilder
        )
    }
}

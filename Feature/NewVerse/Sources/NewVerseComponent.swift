//
//  NewVerseComponent.swift
//  NewVerse
//
//  Created by 공태웅 on 3/18/25.
//

import SwiftUI
import NewVerseInterface
import SelectPhotoInterface

public final class NewVerseComponent<SelectPhotoComponent: SelectPhotoBuilder>: NewVerseBuilder {
    
    // MARK: Lifecycle
    
    public init(dependency: NewVerseDependency<SelectPhotoComponent>) {
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let dependency: NewVerseDependency<SelectPhotoComponent>
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build(isPresented: Binding<Bool>) -> some View {
        NewVerseView(
            isPresented: isPresented,
            viewModel: NewVerseViewModel(useCase: dependency.useCase),
            selectPhotoBuilder: dependency.selectPhotoBuilder
        )
    }
}

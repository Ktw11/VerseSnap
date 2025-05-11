//
//  HomeComponent.swift
//  Home
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI
import HomeInterface
import NewVerseInterface
import Domain

public final class HomeComponent<NewVerseComponent: NewVerseBuilder>: HomeBuilder {
    
    // MARK: Lifecycle
    
    public init(user: User, calendar: Calendar, dependency: HomeDependency<NewVerseComponent>) {
        self.user = user
        self.calendar = calendar
        self.dependency = dependency
    }
    
    // MARK: Properties
    
    private let user: User
    private let calendar: Calendar
    private let dependency: HomeDependency<NewVerseComponent>
    
    // MARK: Methods
    
    @MainActor
    @ViewBuilder
    public func build() -> some View {
        let viewModel = HomeViewModel(
            calendar: calendar,
            useCase: dependency.useCase,
            diaryEventReceiver: dependency.diaryEventReceiver,
            signUpDate: Date(timeIntervalSince1970: user.createdAt)
        )
        HomeView(viewModel: viewModel, newVerseBuilder: dependency.newVerseBuilder)
    }
}

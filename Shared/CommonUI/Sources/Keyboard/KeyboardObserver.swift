//
//  KeyboardObserver.swift
//  CommonUI
//
//  Created by 공태웅 on 4/4/25.
//

import Foundation
import UIKit
import Combine

@Observable
@MainActor
final class KeyboardObserver: Sendable {
    // MARK: Lifecyle
    
    init() {
        setUpEvents()
    }
    
    // MARK: Properties
    
    public private(set) var currentHeight: CGFloat = 0
    private var bag = Set<AnyCancellable>()
}

private extension KeyboardObserver {
    func setUpEvents() {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map { $0.height },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .eraseToAnyPublisher()
        .sink { [weak self] height in
            self?.update(to: height)
        }
        .store(in: &bag)
    }
    
    func update(to height: CGFloat) {
        self.currentHeight = height
    }
}

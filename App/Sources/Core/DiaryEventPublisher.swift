//
//  DiaryEventPublisher.swift
//  App
//
//  Created by 공태웅 on 5/10/25.
//

@preconcurrency import Combine
import Domain

final class DiaryEventPublisher: DiaryEventSender, DiaryEventReceiver {
    
    // MARK: Properties
    
    var eventPublisher: AnyPublisher<DiaryEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private let eventSubject = PassthroughSubject<DiaryEvent, Never>()
    
    // MARK: Methods
    
    func send(_ event: DiaryEvent) {
        eventSubject.send(event)
    }
}

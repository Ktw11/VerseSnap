//
//  MockDiaryEventSender.swift
//  Domain
//
//  Created by 공태웅 on 5/10/25.
//

import Foundation
@testable import Domain

final class MockDiaryEventSender: DiaryEventSender, @unchecked Sendable {
    
    var isSendCalled: Bool = false
    var requestedSendEvent: DiaryEvent?
    
    func send(_ event: DiaryEvent) {
        isSendCalled = true
        requestedSendEvent = event
    }
}

//
//  DiaryEventReceiverPreview.swift
//  PreviewSupport
//
//  Created by 공태웅 on 5/10/25.
//

import Foundation
import Combine
import Domain

public class DiaryEventReceiverPreview: DiaryEventReceiver, @unchecked Sendable {
    public var eventPublisher: AnyPublisher<DiaryEvent, Never> = .init(Empty<DiaryEvent, Never>().eraseToAnyPublisher())
}

public extension DiaryEventReceiverPreview {
    static var preview: DiaryEventReceiver {
        DiaryEventReceiverPreview()
    }
}

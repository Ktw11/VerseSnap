//
//  DiaryEventReceiver.swift
//  Domain
//
//  Created by 공태웅 on 5/10/25.
//

import Foundation
import Combine

public protocol DiaryEventReceiver {
    var eventPublisher: AnyPublisher<DiaryEvent, Never> { get }
}

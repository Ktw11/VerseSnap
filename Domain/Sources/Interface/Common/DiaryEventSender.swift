//
//  DiaryEventSender.swift
//  Domain
//
//  Created by 공태웅 on 5/10/25.
//

import Foundation
import Combine

public protocol DiaryEventSender: Sendable {
    func send(_ event: DiaryEvent)
}

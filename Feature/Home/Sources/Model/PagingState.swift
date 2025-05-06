//
//  PagingState.swift
//  Home
//
//  Created by 공태웅 on 5/6/25.
//

import Foundation

struct PagingState<Cursor> {
    var isFetching: Bool
    var isErrorOccured: Bool
    var isEmpty: Bool
    var isLastPage: Bool
    var cursor: Cursor?
    
    static var initial: PagingState {
        .init(
            isFetching: false,
            isErrorOccured: false,
            isEmpty: false,
            isLastPage: false,
            cursor: nil
        )
    }
}

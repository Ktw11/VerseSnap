//
//  PagingStackType.swift
//  CommonUI
//
//  Created by 공태웅 on 5/6/25.
//

import SwiftUI

public enum PagingStackType {
    case vStack
    case vGrid(columns: [GridItem], spacing: CGFloat)
}

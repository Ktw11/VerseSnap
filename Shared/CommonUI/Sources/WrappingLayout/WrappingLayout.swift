//
//  WrappingLayout.swift
//  CommonUI
//
//  Created by 공태웅 on 3/16/25.
//

import SwiftUI

public struct WrappingLayout: Layout {
    
    // MARK: Lifecycle
    
    public init(hSpacing: CGFloat = 2, vSpacing: CGFloat = 2) {
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
    }
    
    // MARK: Properties
    
    private var hSpacing: CGFloat
    private var vSpacing: CGFloat
    
    // MARK: Methods
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(
            width: proposal.width ?? .zero,
            height: calculateMaxHeight(proposal: proposal, subviews: subviews)
        )
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        
        for subview in subviews {
            let fittedSize = subview.sizeThatFits(proposal)
            
            // 현재 행에 추가했을 때 available width를 초과하면 새 행으로 이동
            if (origin.x + fittedSize.width) > bounds.maxX {
                origin.x = bounds.minX
                origin.y += fittedSize.height + vSpacing
                
                subview.place(at: origin, proposal: proposal)
                origin.x += fittedSize.width + hSpacing
            } else {
                subview.place(at: origin, proposal: proposal)
                origin.x += fittedSize.width + hSpacing
            }
        }
    }
}

private extension WrappingLayout {
    func calculateMaxHeight(proposal: ProposedViewSize, subviews: Subviews) -> CGFloat {
        var origin: CGPoint = .zero

        for subview in subviews {
            let fittedSize = subview.sizeThatFits(proposal)
            
            // 현재 행에 추가했을 때 available width를 초과하면 새 행으로 이동
            if (origin.x + fittedSize.width) > (proposal.width ?? .zero) {
                origin.x = 0
                origin.y += fittedSize.height + vSpacing
                origin.x += fittedSize.width + hSpacing
            } else {
                origin.x += fittedSize.width + hSpacing
            }
            
            if subview == subviews.last {
                origin.y += fittedSize.height
            }
        }
        
        return origin.y
    }
}

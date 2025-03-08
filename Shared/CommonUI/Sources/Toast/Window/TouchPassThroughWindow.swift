//
//  TouchPassThroughWindow.swift
//  CommonUI
//
//  Created by 공태웅 on 3/8/25.
//

import Foundation
import UIKit

final class TouchPassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        guard let rootView = rootViewController?.view else { return nil }

        if #available(iOS 18, *) {
            // https://forums.developer.apple.com/forums/thread/762292
            for subview in rootView.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: rootView)
                if subview.hitTest(convertedPoint, with: event) != nil {
                    return hitView
                }
            }
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}

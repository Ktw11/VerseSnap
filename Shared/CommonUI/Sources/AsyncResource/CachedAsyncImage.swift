//
//  CacheAsyncImage.swift
//  CommonUI
//
//  Created by 공태웅 on 5/5/25.
//

import SwiftUI
import Kingfisher

public struct CachedAsyncImage: View {
    
    // MARK: Lifecycle
    
    public init(
        url: URL?,
        config: Configuration = .default
    ) {
        self.url = url
        self.config = config
    }
    
    // MARK: Definitions
    
    public struct Configuration: Sendable {
        public enum ContentMode: Sendable {
            case scaleToFill
            case scaleToFit
        }
        
        let cancelOnDisappear: Bool
        let fadeDuration: Double?
        let contentMode: ContentMode
        
        public static var `default`: Configuration {
            .init(
                cancelOnDisappear: true,
                fadeDuration: 0.25,
                contentMode: .scaleToFill
            )
        }
    }
    
    // MARK: Properties
    
    private let url: URL?
    private let config: Configuration
    private var placeholder: (() -> AnyView)?

    public var body: some View {
        KFImage(url)
            .placeholder {
                if let placeholder = placeholder {
                    placeholder()
                } else {
                    ProgressView()
                }
            }
            .conditional(config.fadeDuration != nil) {
                $0.fade(duration: config.fadeDuration ?? 0.25)
            }
            .cancelOnDisappear(config.cancelOnDisappear)
            .resizable()
            .switch(on: config.contentMode) { view, mode in
                switch mode {
                case .scaleToFill:
                    view.scaledToFill()
                case .scaleToFit:
                    view.scaledToFit()
                }
            }
    }
}

public extension CachedAsyncImage {
    func placeholder<PlaceHolder: View>(@ViewBuilder _ build: @escaping () -> PlaceHolder) -> Self {
        var view = self
        view.placeholder = { AnyView(build()) }
        return view
    }
}

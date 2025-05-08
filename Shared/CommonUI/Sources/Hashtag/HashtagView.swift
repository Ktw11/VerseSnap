//
//  HashtagView.swift
//  CommonUI
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI

public struct HashtagView: View {
    
    // MARK: Lifecycle
    
    public init(
        hashtag: Binding<Hashtag>,
        maxWidth: Binding<CGFloat>,
        isFocused: FocusState<UUID?>.Binding,
        icon: Image?,
        eventListener: HashtagEventListener?,
        backgroundColor: Color = CommonUIAsset.Color.placeholderBG.swiftUIColor
    ) {
        self._hashtag = hashtag
        self._maxWidth = maxWidth
        self._isFocused = isFocused
        self.icon = icon
        self.eventListener = eventListener
        self.backgroundColor = backgroundColor
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let textFont: Font? = .suite(size: 13, weight: .regular)
        static let spacing: CGFloat = 3
        static let iconSize: CGSize = CGSize(width: 16, height: 16)
        static let leadingPadding: CGFloat = 10
        static func trailingPadding(isIconHidden: Bool) -> CGFloat {
            isIconHidden ? 10 : 5
        }
        
        static func textWidth(
            prefixWidth: CGFloat,
            textWidth: CGFloat,
            maxWidth: CGFloat,
            isIconHidden: Bool
        ) -> CGFloat {
            let paddings: CGFloat = leadingPadding + trailingPadding(isIconHidden: isIconHidden) + (spacing * 2)
            let availableWidth = maxWidth - paddings - prefixWidth - iconSize.width - 0.1
            return min(textWidth, availableWidth)
        }
    }
    
    // MARK: Properties
    
    @Binding var hashtag: Hashtag
    @Binding var maxWidth: CGFloat
    @FocusState.Binding var isFocused: UUID?
    @State private var hashtagPrefixWidth = CGFloat.zero
    @State private var textFieldWidth = CGFloat.zero
    
    private let icon: Image?
    private let backgroundColor: Color
    private weak var eventListener: HashtagEventListener?
    
    public var body: some View {
        HStack(spacing: Constants.spacing) {
            hashtagPrefixView()
            
            textFieldView()
                .frame(width: textFieldWidth)
            
            iconView()
        }
        .padding(.leading, Constants.leadingPadding)
        .padding(.trailing, Constants.trailingPadding(isIconHidden: icon == nil))
        .padding(.vertical, 4)
        .background {
            backgroundColor
                .clipShape(Capsule())
        }
        .onTapGesture {
            isFocused = hashtag.id
        }
    }
}

private extension HashtagView {
    @ViewBuilder
    func hashtagPrefixView() -> some View {
        Text("#")
            .foregroundStyle(.white)
            .font(Constants.textFont)
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { newValue in
                hashtagPrefixWidth = newValue
            }
    }
    
    @ViewBuilder
    func textFieldView() -> some View {
        ZStack(alignment: .leading) {
            if hashtag.value.isEmpty {
                Text("해시태그를 입력해주세요")
                    .font(Constants.textFont)
                    .foregroundStyle(Color.gray)
            }
            
            TextField("",text: $hashtag.value)
                .lengthLimit(text: $hashtag.value, maxLength: 15)
                .tint(Color.white)
                .focused($isFocused, equals: hashtag.id)
                .font(Constants.textFont)
                .foregroundStyle(.white)
                .background {
                    Text(hashtag.value.isEmpty ? "해시태그를 입력해주세요" : hashtag.value)
                        .font(Constants.textFont)
                        .fixedSize()
                        .hidden()
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.size.width
                        } action: { newValue in
                            textFieldWidth = Constants.textWidth(
                                prefixWidth: hashtagPrefixWidth,
                                textWidth: newValue,
                                maxWidth: maxWidth,
                                isIconHidden: icon == nil
                            )
                        }
                }
                .onSubmit {
                    eventListener?.didSubmitHashtag(hashtag)
                }
        }
    }
    
    @ViewBuilder
    func iconView() -> some View {
        if let icon {
            icon
                .resizable()
                .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                .onTapGesture {
                    eventListener?.removeHashtag(id: hashtag.id)
                }
        }
    }
}

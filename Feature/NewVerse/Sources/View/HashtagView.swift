//
//  HashtagView.swift
//  NewDiary
//
//  Created by 공태웅 on 3/18/25.
//

import SwiftUI
import CommonUI

struct HashtagView: View {
    
    // MARK: Definitions
    
    private enum Constants {
        static let textFont: Font? = .suite(size: 13, weight: .regular)
        static let spacing: CGFloat = 3
        static let iconSize: CGSize = CGSize(width: 16, height: 16)
        static let leadingPadding: CGFloat = 10
        static let trailingPadding: CGFloat = 5
        
        static func textWidth(
            prefixWidth: CGFloat,
            textWidth: CGFloat,
            maxWidth: CGFloat
        ) -> CGFloat {
            let paddings: CGFloat = leadingPadding + trailingPadding + (spacing * 2)
            let availableWidth = maxWidth - paddings - prefixWidth - iconSize.width - 0.1
            return min(textWidth, availableWidth)
        }
    }
    
    // MARK: Properties
    
    @Binding var hashtag: Hashtag
    @Binding var maxWidth: CGFloat
    @FocusState.Binding var isFocused: UUID?
    let icon: Image
    let eventListener: HashtagEventListener
    @State private var hashtagPrefixWidth = CGFloat.zero
    @State private var textFieldWidth = CGFloat.zero
    
    var body: some View {
        HStack(spacing: Constants.spacing) {
            hashtagPrefixView()
            
            textFieldView()
                .frame(width: textFieldWidth)
            
            iconView()
        }
        .padding(.leading, Constants.leadingPadding)
        .padding(.trailing, Constants.trailingPadding)
        .padding(.vertical, 4)
        .background {
            CommonUIAsset.Color.placeholderBG.swiftUIColor
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
                                maxWidth: maxWidth
                            )
                        }
                }
                .onSubmit {
                    eventListener.didSubmitHashtag(hashtag)
                }
        }
    }
    
    @ViewBuilder
    func iconView() -> some View {
        icon
            .resizable()
            .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
            .onTapGesture {
                eventListener.removeHashtag(id: hashtag.id)
            }
    }
}

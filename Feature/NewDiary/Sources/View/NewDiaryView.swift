//
//  NewDiaryView.swift
//  NewDiary
//
//  Created by 공태웅 on 3/16/25.
//

import SwiftUI
import CommonUI

public struct NewDiaryView: View {
    
    // MARK: Lifecycle
    
    public init(viewModel: NewDiaryViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    
    @Bindable private var viewModel: NewDiaryViewModel
    @FocusState private var isHashtagFocused: UUID?
    @State private var keyboardHeight: CGFloat = 0
    @State private var hashtagsViewMaxWidth: CGFloat = 0
    @State private var isInputViewPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    CommonUIAsset.Image.icExitBig.swiftUIImage
                        .resizable()
                        .frame(size: 24)
                        .onTapGesture {
                            dismiss()
                        }
                        .padding(.leading, 27)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
                    .frame(height: 45)

                ZStack {
                    if keyboardHeight == 0 {
                        VStack {
                            dateHeaderView()
                            
                            imagePickerView()
                                .padding(.bottom, 15)
                        }
                    } else {
                        Spacer()
                            .frame(height: 15)
                    }
                }
                
                hashtagView()
                    .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.width
                    } action: {
                        hashtagsViewMaxWidth = $0
                    }
                
                if keyboardHeight > 0 {
                    Spacer()
                        .frame(minHeight: 15)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            isHashtagFocused = nil
        }
        .animation(.easeInOut, value: keyboardHeight)
        .transition(.opacity)
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
        .observeKeyboardHeight($keyboardHeight)
    }
}

private extension NewDiaryView {
    @ViewBuilder
    func dateHeaderView() -> some View {
        Text("2025.6.17")
            .font(.suite(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .padding(.bottom, 9)
        
        Text("오후 12:30")
            .font(.suite(size: 14, weight: .regular))
            .foregroundStyle(.white)
            .padding(.bottom, 30)
    }
    
    @ViewBuilder
    func imagePickerView() -> some View {
        CommonUIAsset.Color.placeholderBG.swiftUIColor
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .aspectRatio(0.65, contentMode: .fill)
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
            .overlay {
                Text("사진 선택하기")
                    .foregroundStyle(.white)
                    .font(.suite(size: 15, weight: .regular))
            }
    }
    
    @ViewBuilder
    func hashtagView() -> some View {
        WrappingLayout(hSpacing: 5, vSpacing: 5) {
            ForEach($viewModel.hashtags, id: \.id) { hashtag in
                HashtagView(
                    hashtag: hashtag,
                    maxWidth: $hashtagsViewMaxWidth,
                    isFocused: $isHashtagFocused,
                    icon: CommonUIAsset.Image.icExit.swiftUIImage,
                    eventListener: viewModel
                )
            }
        }
        .padding(.all, 10)
    }
    
    @ViewBuilder
    func createButton() -> some View {
        Text("삼행시 생성하기")
            .font(.suite(size: 16, weight: .regular))
            .foregroundStyle(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background {
                Color.white.opacity(0.2)
                    .clipShape(Capsule())
            }
    }
}

#Preview {
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        NewDiaryView(viewModel: NewDiaryViewModel())
    }
}

//
//  NewDiaryView.swift
//  NewDiary
//
//  Created by 공태웅 on 3/16/25.
//

import SwiftUI
import CommonUI

public struct NewDiaryView: View {

    // MARK: Properties
    
    @State private var keyboard = KeyboardObserver()
    @State private var hashtags: [Hashtag] = [
        .init(value: "")
    ]
    @State private var hashtagsViewMaxWidth: CGFloat = 0
    @State private var isInputViewPresented: Bool = false
    
    public var body: some View {
        VStack {
            Spacer()
                .frame(height: 45)
            
            Text("2025.6.17")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding(.bottom, 9)
            
            Text("오후 12:30")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white)
                .padding(.bottom, 30)
            
            imagePickerView()
                .padding(.bottom, 15)
            
            Spacer()

            ScrollView {
                hashtagView()
                
                Spacer()
            }
            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: {
                hashtagsViewMaxWidth = $0
            }
            
            createButton()
                .padding(.bottom, 20)
        }
        .padding(.bottom, keyboard.currentHeight)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeOut, value: keyboard.currentHeight)
    }
}

private extension NewDiaryView {
    @ViewBuilder
    func imagePickerView() -> some View {
        CommonUIAsset.Color.secondaryBackground.swiftUIColor
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .aspectRatio(0.65, contentMode: .fill)
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
            .overlay {
                Text("사진 선택하기")
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .regular))
            }
    }
    
    @ViewBuilder
    func hashtagView() -> some View {
        WrappingLayout() {
            ForEach($hashtags, id: \.id) { hashtag in
                HashtagView(
                    hashtag: hashtag,
                    maxWidth: $hashtagsViewMaxWidth,
                    icon: CommonUIAsset.Image.icExit.swiftUIImage
                )
            }
        }
    }
    
    @ViewBuilder
    func createButton() -> some View {
        Text("삼행시 생성하기")
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background {
                CommonUIAsset.Color.secondaryBackground.swiftUIColor
                    .clipShape(Capsule())
            }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        NewDiaryView()
    }
}

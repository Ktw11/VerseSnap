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
    
    public var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            
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
            
            hashtagView()
            
            createButton()
                .padding(.bottom, 20)
        }
    }
}

private extension NewDiaryView {
    @ViewBuilder
    func imagePickerView() -> some View {
        CommonUIAsset.secondaryBackground.swiftUIColor
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
        ScrollView {
            Rectangle().fill(Color.blue)
        }
    }
    
    @ViewBuilder
    func createButton() -> some View {
        Text("삼행시 생성하기")
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background {
                CommonUIAsset.secondaryBackground.swiftUIColor
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

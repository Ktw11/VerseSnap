//
//  HashtagView.swift
//  NewDiary
//
//  Created by 공태웅 on 3/18/25.
//

import SwiftUI
import CommonUI

struct HashtagView: View {
    
    // MARK: Lifecycle
    
    init(text: String?, icon: Image) {
        self.text = text
        self.icon = icon
    }
    
    // MARK: Properties
    
    let text: String?
    let icon: Image
    
    var body: some View {
        HStack(spacing: 3) {
            if let text {
                Text(text)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.white)
            }
            
            icon
                .resizable()
                .frame(size: 16)
        }
        .padding(.leading, text == nil ? 7 : 10)
        .padding(.trailing, text == nil ? 7 : 5)
        .padding(.vertical, 4)
        .background {
            Color.black.opacity(0.3)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    ZStack {
        Color.gray
            .ignoresSafeArea()
        
        VStack(spacing: 10) {
            HashtagView(text: "hashtag", icon: CommonUIAsset.Image.icExit.swiftUIImage)
            
            HashtagView(text: nil, icon: CommonUIAsset.Image.icPlus.swiftUIImage)
        }
    }
}

//
//  ProfileView.swift
//  Profile
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI
import CommonUI

public struct ProfileView: View {
    
    // MARK: Properties
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: "My Profile")
                .foregroundStyle(.white)
                .font(.suite(size: 28, weight: .bold))
                .padding(.top, 32)
                .padding(.horizontal, 30)
            
            Spacer()
                .frame(height: 40)
            
            VStack(alignment: .leading) {
                HStack {
                    nicknameView()
                    
                    Spacer()
                    
                    ProfileAsset.icEdit.swiftUIImage
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.white)
                        .frame(size: 24)
                }
                
                Spacer()
                    .frame(height: 14)
                
                #warning("text 반영 필요")
                Text(verbatim: "오늘의 삼행시를 기록해보세요")
                    .foregroundStyle(.white)
                    .font(.suite(size: 16, weight: .regular))
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 15)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 25)
            
            Spacer()
                .frame(height: 50)
            
            VStack(spacing: 20) {
                menuButton(title: "로그아웃") {
                    #warning("action 반영 필요")
                }
                
                menuButton(title: "회원탈퇴") {
                    #warning("action 반영 필요")
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

private extension ProfileView {
    @ViewBuilder
    func nicknameView() -> some View {
        #warning("text 반영 필요")
        Text("땡땡땡" + " 님")
            .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func menuButton(title: String, action: (@escaping () -> Void)) -> some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.suite(size: 18, weight: .regular))
        })
        .padding(.vertical, 10)
    }
}

#if DEBUG
import PreviewSupport

#Preview {
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        ProfileView()
    }
}

#endif

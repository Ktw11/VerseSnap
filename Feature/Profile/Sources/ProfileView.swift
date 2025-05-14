//
//  ProfileView.swift
//  Profile
//
//  Created by 공태웅 on 5/11/25.
//

import SwiftUI
import CommonUI

public struct ProfileView: View {
    
    // MARK: Lifecycle
    
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    
    @FocusState private var isFocused: Bool
    @Bindable private var viewModel: ProfileViewModel
    
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
                nicknameView(isEditMode: viewModel.isNicknameFocused, isNicknameUpdating: viewModel.isNicknameUpdating)
                
                Spacer()
                    .frame(height: 14)
                
                #warning("text 반영 필요")
                Text(verbatim: "오늘의 삼행시를 기록해보세요")
                    .foregroundStyle(.white)
                    .font(.suite(size: 16, weight: .regular))
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 15)
            .background(Color.white.opacity(0.04))
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
        .clipShape(Rectangle())
        .onTapGesture {
            viewModel.isNicknameFocused = false
        }
    }
}

private extension ProfileView {
    @ViewBuilder
    func nicknameView(isEditMode: Bool, isNicknameUpdating: Bool) -> some View {
        HStack {
            if isEditMode {
                TextField("", text: $viewModel.editingNickname)
                    .lengthLimit(text: $viewModel.editingNickname, maxLength: 8)
                    .tint(Color.white)
                    .focused($isFocused)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white)
                    .onAppear {
                        isFocused = true
                    }
            } else {
                Text(viewModel.attributedNickname)
            }
            
            Spacer()
            
            if isEditMode {
                if isNicknameUpdating {
                    LoadingView(size: 20)
                } else {
                    Button(action: {
                        viewModel.didTapNicknameChangeDone()
                    }, label: {
                        Text("완료")
                            .font(.suite(size: 15, weight: .regular))
                            .foregroundStyle(Color.white)
                    })
                }
            } else {
                ProfileAsset.icEdit.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white)
                    .frame(size: 24)
                    .onTapGesture {
                        viewModel.isNicknameFocused = true
                    }
            }
        }
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
    let viewModel = ProfileViewModel(
        nickname: "nickname",
        userUseCase: UserUseCasePreview.preview,
        signOutUseCase: SignOutUseCasePreview.preview,
        appStateUpdator: GlobalStateUpdatorPreview.preview
    )
    
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        ProfileView(viewModel: viewModel)
    }
}

#endif

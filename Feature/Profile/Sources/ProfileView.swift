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
                    viewModel.didTapSignOut()
                }
                
                menuButton(title: "회원탈퇴") {
                    viewModel.didTapDeleteAccount()
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .clipShape(Rectangle())
        .onTapGesture {
            viewModel.isNicknameFocused = false
        }
        .modalView($viewModel.isDeleteAccountModalPresented) {
            DeleteAccountConfirmView(
                onConfirm: {
                    viewModel.isDeleteAccountModalPresented = false
                    viewModel.confirmDeleteAccount()
                },
                onDismiss: {
                    viewModel.isDeleteAccountModalPresented = false
                }
            )
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

private struct DeleteAccountConfirmView: View {
    let onConfirm: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("회원탈퇴")
                .font(.suite(size: 23, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("정말로 탈퇴하시겠습니까? 탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.")
                .font(.suite(size: 17, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                capsuleButton(
                    title: "취소",
                    foregroundColor: .white,
                    backgroundColor: Color.gray.opacity(0.3),
                    action: { onDismiss() }
                )
                
                capsuleButton(
                    title: "확인",
                    foregroundColor: .black,
                    backgroundColor: Color.white.opacity(0.7),
                    action: { onConfirm() }
                )
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 24)
    }
    
    @ViewBuilder
    func capsuleButton(
        title: String,
        foregroundColor: Color,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(foregroundColor)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}

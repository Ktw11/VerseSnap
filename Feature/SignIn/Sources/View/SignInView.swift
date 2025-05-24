//
//  SignInView.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI
import CommonUI

public struct SignInView: View {
    
    // MARK: Lifecycle
    
    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    
    private let viewModel: SignInViewModel
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("Sign-In")
                    .foregroundStyle(Color.white)
                    .font(.largeTitle)
                
                Spacer()
                
                VStack(spacing: 10) {
                    ForEach(viewModel.accounts, id: \.rawValue) { account in
                        SignInButton(
                            icon: account.icon,
                            buttonText: account.buttonText,
                            backgroundColor: account.backgroundColor
                        ).onTapGesture {
                            viewModel.didTapSignInButton(account: account)
                        }
                    }
                }
                .padding(.horizontal, 36)
                .padding(.bottom, 52)
            }
            
            Color.black.opacity(0.7)
                .overlay(alignment: .center) {
                    LoadingView()
                }
                .opacity(viewModel.showProgressView ? 1.0 : 0)
                .ignoresSafeArea()
        }
    }
}

#if DEBUG
import PreviewSupport

#Preview {
    SignInView(
        viewModel: .init(
            dependency: .init(
                accounts: [.apple, .kakao],
                useCase: AuthUseCasePreview.preview,
                appStateUpdator: GlobalStateUpdatorPreview.preview
            )
        )
    )
}
#endif

private struct SignInButton: View {
    
    // MARK: Properties
    
    let icon: Image
    let buttonText: String
    let backgroundColor: Color
    
    var body: some View {
        HStack(alignment: .center) {
            icon
                .resizable()
                .frame(width: 24, height: 24)
            
            Spacer()

            Text("Sign in with \(buttonText)", bundle: .module)
                .font(.system(size: 16, weight: .semibold))
            
            Spacer()
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 24)
        .frame(height: 48)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

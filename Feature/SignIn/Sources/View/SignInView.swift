//
//  SignInView.swift
//  SignIn
//
//  Created by 공태웅 on 2/22/25.
//

import SwiftUI

public struct SignInView: View {
    
    // MARK: Lifecycle
    
    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    
    private let viewModel: SignInViewModel
    
    public var body: some View {
        VStack {
            Spacer()
            
            Text("로그인")
                .foregroundStyle(Color.white)
                .font(.largeTitle)
            
            Spacer()
            
            VStack(spacing: 10) {
                ForEach(viewModel.accounts, id: \.rawValue) { account in
                    Button(action: {
                        viewModel.didTapSignInButton(account: account)
                    }, label: {
                        SignInButton(
                            icon: account.icon,
                            buttonText: account.buttonText,
                            backgroundColor: account.backgroundColor
                        )
                    })
                }
            }
            .padding(.horizontal, 36)
            .padding(.bottom, 52)
        }
    }
}

#Preview {
    SignInView(
        viewModel: .init(
            dependency: .init(
                accounts: [.apple, .kakao],
                useCase: MockSignInUseCase.preview
            )
        )
    )
}

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

            Text("\(buttonText)로 로그인", bundle: .module)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 24)
        .frame(height: 48)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

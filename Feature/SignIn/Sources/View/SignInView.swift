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
                .font(.largeTitle)
            
            Spacer()
            
            VStack(spacing: 10) {
                ForEach(viewModel.signInTypes, id: \.rawValue) { type in
                    Button(action: {
                        #warning("버튼 액션 추가 필요")
                    }, label: {
                        SignInButton(type: type)
                    })
                }
            }
            .padding(.horizontal, 36)
            .padding(.bottom, 52)
        }
    }
}

#Preview {
    SignInView(viewModel: .init(dependency: .init(signInTypes: [.apple, .kakao])))
}

private struct SignInButton: View {
    
    // MARK: Properties
    
    let type: SignInType
    
    var body: some View {
        HStack(alignment: .center) {
            type.icon
                .resizable()
                .frame(width: 24, height: 24)
            
            Spacer()

            Text("\(type.buttonText)로 로그인", bundle: .module)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 24)
        .frame(height: 48)
        .background(type.backgroundColor)
        .clipShape(Capsule())
    }
}

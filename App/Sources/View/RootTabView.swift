//
//  RootTabView.swift
//  App
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI
import CommonUI
import Domain
import HomeInterface
import NewVerseInterface

struct RootTabView: View {

    // MARK: Properties
    
    @Environment(\.userSessionContainer) private var userSessionContainer
    @State private var selected: TabSelection = .home
    @State private var isNewVersePresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                ZStack {
                    CommonUIAsset.Color.mainBG.swiftUIColor
                        .ignoresSafeArea()
                    
                    userSessionContainer?.homeBuilder.build()
                }
                .tag(TabSelection.home)
                .toolbarVisibility(.hidden, for: .tabBar)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                ZStack {
                    CommonUIAsset.Color.mainBG.swiftUIColor
                        .ignoresSafeArea()
                    
                    userSessionContainer?.profileBuilder.build()
                }
                .tag(TabSelection.profile)
                .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            CustomTabView(selected: $selected, isNewVersePresented: $isNewVersePresented)
                .background(CommonUIAsset.Color.mainBG.swiftUIColor)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .fullScreenCover(isPresented: $isNewVersePresented) {
            userSessionContainer?.newVerseBuilder.build(isPresented: $isNewVersePresented)
                .presentationBackground(CommonUIAsset.Color.mainBG.swiftUIColor)
        }
    }
}

private struct CustomTabView: View {
    
    // MARK: Definitions
    
    private enum Constants {
        static let tabIconSize: CGSize = .init(width: 24, height: 24)
    }
    
    // MARK: Properties
    
    @Binding var selected: TabSelection
    @Binding var isNewVersePresented: Bool

    var body: some View {
        HStack(alignment: .center) {
            
            Spacer()
                .frame(width: 40)
    
            Button {
                selected = .home
            } label: {
                VerseSnapAsset.Image.icHomeTab.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(selected == .home ? Color.white : Color.white.opacity(0.3))
                    .frame(size: Constants.tabIconSize)
            }
           
            Spacer()
            
            Button {
                isNewVersePresented.toggle()
            } label: {
                VerseSnapAsset.Image.icPlusTab.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.white.opacity(0.3))
                    .frame(size: Constants.tabIconSize)
            }
            
            Spacer()
            
            Button {
                selected = .profile
            } label: {
                VerseSnapAsset.Image.icProfileTab.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(selected == .profile ? Color.white : Color.white.opacity(0.3))
                    .frame(size: Constants.tabIconSize)
            }
            
            Spacer()
                .frame(width: 40)
        }
        .frame(height: 60)
    }
}

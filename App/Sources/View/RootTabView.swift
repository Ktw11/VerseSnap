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
                
                #warning("Profile View 구현 필요")
                VStack {
                    Spacer()
                    Text("@@@ PROFILE VIEW")
                        .foregroundStyle(.white)
                    Spacer()
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
                AppAsset.Image.icHomeTab.swiftUIImage
                    .resizable()
                    .frame(size: Constants.tabIconSize)
            }
           
            Spacer()
            
            Button {
                isNewVersePresented.toggle()
            } label: {
                AppAsset.Image.icPlusTab.swiftUIImage
                    .resizable()
                    .frame(size: Constants.tabIconSize)
            }
            
            Spacer()
            
            Button {
                selected = .profile
            } label: {
                AppAsset.Image.icProfileTab.swiftUIImage
                    .resizable()
                    .frame(size: Constants.tabIconSize)
            }
            
            Spacer()
                .frame(width: 40)
        }
        .frame(height: 60)
    }
}

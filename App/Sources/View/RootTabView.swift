//
//  RootTabView.swift
//  App
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI
import CommonUI
import HomeInterface
import NewDiaryInterface

struct RootTabView<
    HomeComponent: HomeBuilder,
    NewDiaryComponent: NewDiaryBuilder
>: View {
    // MARK: Lifecycle
    
    init(
        homeBuilder: HomeComponent,
        newDiaryBuilder: NewDiaryComponent
    ) {
        self.homeBuilder = homeBuilder
        self.newDiaryBuilder = newDiaryBuilder
    }
    
    // MARK: Properties
    
    @State private var selected: TabSelection = .home
    @State private var isNewDiaryPresented: Bool = false
    private let homeBuilder: HomeComponent
    private let newDiaryBuilder: NewDiaryComponent
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                homeBuilder.build()
                    .padding(.horizontal, 24)
                    .tag(TabSelection.home)
                    .toolbarVisibility(.hidden, for: .tabBar)
                    .background(CommonUIAsset.Color.mainBG.swiftUIColor)
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
                .background(CommonUIAsset.Color.mainBG.swiftUIColor)
            }
            
            CustomTabView(selected: $selected, isNewDiaryPresented: $isNewDiaryPresented)
                .padding(.bottom, 15)
                .background(CommonUIAsset.Color.mainBG.swiftUIColor)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $isNewDiaryPresented) {
            newDiaryBuilder.build(isPresented: $isNewDiaryPresented)
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
    @Binding var isNewDiaryPresented: Bool

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
                isNewDiaryPresented.toggle()
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

//
//  RootTabView.swift
//  App
//
//  Created by 공태웅 on 3/11/25.
//

import SwiftUI
import HomeInterface

struct RootTabView<HomeComponent: HomeBuilder>: View {
    // MARK: Lifecycle
    
    init(
        homeBuilder: HomeComponent
    ) {
        self.homeBuilder = homeBuilder
    }
    
    // MARK: Properties
    
    @State private var selected: TabSelection = .home
    private let homeBuilder: HomeComponent
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                homeBuilder.build()
                    .padding(.horizontal, 24)
                    .tag(TabSelection.home)
                    .toolbarVisibility(.hidden, for: .tabBar)
                    .background(Color.black)
                
                #warning("Profile View 구현 필요")
                VStack {
                    Spacer()
                    Text("@@@ PROFILE VIEW")
                        .foregroundStyle(.white)
                    Spacer()
                }
                .tag(TabSelection.profile)
                .toolbarVisibility(.hidden, for: .tabBar)
                .background(Color.black)
            }
            
            CustomTabView(selected: $selected)
                .padding(.bottom, 15)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

private struct CustomTabView: View {
    
    // MARK: Definitions
    
    private enum Constants {
        static let tabIconSize: CGSize = .init(width: 24, height: 24)
    }
    
    // MARK: Properties
    
    @Binding var selected: TabSelection

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
                #warning("탭 동작 구현 필요")
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

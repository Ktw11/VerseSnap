//
//  DetailDiaryView.swift
//  Home
//
//  Created by 공태웅 on 5/8/25.
//

import SwiftUI
import CommonUI

struct DetailDiaryView: View {
    
    // MARK: Properties
    
    @Binding var viewModel: DetailDiaryViewModel
    let dismiss: (() -> Void)
    let didTapFavorite: ((Bool) -> Void)
    
    @State private var image: Image?
    @State private var hashtagsViewMaxWidth: CGFloat = 0
    @FocusState private var isHashtagFocused: UUID?
    
    var body: some View {
        ZStack {
            CommonUIAsset.Color.mainBG.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                headerView(isFavorte: viewModel.isFavorte)
                
                Spacer()

                VStack {
                    dateTimeView()
                    
                    imageView()
                }
                
                hashtagView()
                    .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.width
                    } action: {
                        hashtagsViewMaxWidth = $0
                    }
                
                Spacer()
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background {
                backgroundBlurImage()
            }
        }
        .task {
            guard let url = URL(string: viewModel.imageURL) else { return }
            self.image = try? await CachedRemoteResource.fetchImage(url: url)
        }
    }
}

private extension DetailDiaryView {
    @ViewBuilder
    func headerView(isFavorte: Bool) -> some View {
        HStack {
            Button(action: {
                dismiss()
            }, label: {
                CommonUIAsset.Image.icExitBig.swiftUIImage
                    .resizable()
                    .frame(size: 24)
                    .padding(.leading, 27)
            })
            
            Spacer()
            
            Button(action: {
                viewModel.isFavorte.toggle()
                
                didTapFavorite(!isFavorte)
            }, label: {
                let icon = isFavorte ? HomeAsset.icHeartFill.swiftUIImage : HomeAsset.icHeartEmpty.swiftUIImage
                
                icon
                    .resizable()
                    .frame(size: 24)
                    .padding(.trailing, 27)
            })
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func dateTimeView() -> some View {
        VStack(spacing: 10) {
            Text(viewModel.dateString)
                .font(.suite(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
            
            Text(viewModel.timeString)
                .font(.suite(size: 14, weight: .regular))
                .foregroundStyle(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
        }
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    func imageView() -> some View {
        CommonUIAsset.Color.placeholderBG.swiftUIColor
            .aspectRatio(viewModel.imageRatio, contentMode: .fit)
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
            .overlay {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .overlay(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 120)
            }
            .overlay(alignment: .bottomLeading) {
                if let verse = viewModel.verse {
                    Text(verse)
                        .foregroundStyle(Color.white)
                        .minimumScaleFactor(0.6)
                        .padding(.leading, 17)
                        .padding(.bottom, 17)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, 5)
    }
    
    @ViewBuilder
    func hashtagView() -> some View {
        if !viewModel.hashtags.isEmpty {
            WrappingLayout(hSpacing: 5, vSpacing: 5) {
                ForEach(viewModel.hashtags, id: \.id) { hashtag in
                    HashtagView(
                        hashtag: .constant(hashtag),
                        maxWidth: $hashtagsViewMaxWidth,
                        isFocused: $isHashtagFocused,
                        backgroundColor: Color.white.opacity(0.2)
                    )
                }
            }
            .allowsHitTesting(false)
            .padding(.all, 10)
            .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    func backgroundBlurImage() -> some View {
        if let image {
            image
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 5)
                .overlay {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var isPresented: Bool = false
    @Previewable @State var viewModel: DetailDiaryViewModel = .init(
        from: .init(
            id: UUID().uuidString,
            imageURL: "https://randomuser.me/api/portraits/men/50.jpg",
            hashtags: ["해시해", "hashash"],
            createdAt: Date().timeIntervalSince1970,
            verses: ["삼: 심", "행: 행"],
            isFavorite: true
        ),
        imageRatio: 0.65
    )
    
    DetailDiaryView(
        viewModel: $viewModel,
        dismiss: { Void() },
        didTapFavorite: { _ in Void() }
    )
}
#endif

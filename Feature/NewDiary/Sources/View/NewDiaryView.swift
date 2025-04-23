//
//  NewDiaryView.swift
//  NewDiary
//
//  Created by 공태웅 on 3/16/25.
//

import SwiftUI
import CommonUI
import SelectPhotoInterface

public struct NewDiaryView<SelectPhotoComponent: SelectPhotoBuilder>: View {
    
    // MARK: Lifecycle
    
    public init(
        isPresented: Binding<Bool>,
        viewModel: NewDiaryViewModel,
        selectPhotoBuilder: SelectPhotoComponent
    ) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        self.selectPhotoBuilder = selectPhotoBuilder
    }
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    @Bindable private var viewModel: NewDiaryViewModel
    
    @FocusState private var isHashtagFocused: UUID?
    @State private var keyboardHeight: CGFloat = 0
    @State private var hashtagsViewMaxWidth: CGFloat = 0
    @State private var isInputViewPresented: Bool = false
    @State private var isPhotoPickerPresented: Bool = false
    
    private let selectPhotoBuilder: SelectPhotoComponent
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack {
                headerView()
                
                Spacer()
                    .frame(height: 30)

                ZStack {
                    if keyboardHeight > 0 {
                        Spacer()
                            .frame(height: 15)
                    } else {
                        VStack {
                            dateView()
                            
                            imagePickerView()
                                .onTapGesture {
                                    self.isPhotoPickerPresented = true
                                }
                                .padding(.bottom, 5)
                        }
                    }
                }
                
                hashtagView()
                    .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.width
                    } action: {
                        hashtagsViewMaxWidth = $0
                    }
                
                createButton()
                    .opacity(keyboardHeight > 0 || viewModel.croppedImage == nil ? 0 : 1)
                    .animation(nil, value: keyboardHeight)
                    .animation(.easeInOut, value: viewModel.croppedImage)
                
                if keyboardHeight > 0 {
                    Spacer()
                        .frame(minHeight: 15)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            isHashtagFocused = nil
        }
        .animation(.easeInOut, value: keyboardHeight)
        .transition(.opacity)
        .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
        .observeKeyboardHeight($keyboardHeight)
        .fullScreenCover(isPresented: $isPhotoPickerPresented) {
            selectPhotoBuilder.build(croppedImage: $viewModel.croppedImage, ratio: viewModel.imageRatio)
                .presentationBackground(CommonUIAsset.Color.mainBG.swiftUIColor)
        }
    }
}

private extension NewDiaryView {
    @ViewBuilder
    func headerView() -> some View {
        HStack {
            CommonUIAsset.Image.icExitBig.swiftUIImage
                .resizable()
                .frame(size: 24)
                .onTapGesture {
                    isPresented.toggle()
                }
                .padding(.leading, 27)
            
            Spacer()
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func dateView() -> some View {
        Text(viewModel.dateString)
            .font(.suite(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .padding(.bottom, 30)
    }
    
    @ViewBuilder
    func imagePickerView() -> some View {
        CommonUIAsset.Color.placeholderBG.swiftUIColor
            .aspectRatio(viewModel.imageRatio, contentMode: .fit)
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
            .overlay {
                if let image = viewModel.croppedImage {
                    image
                        .resizable()
                        .aspectRatio(0.65, contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("사진 선택하기")
                        .foregroundStyle(.white)
                        .font(.suite(size: 15, weight: .regular))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    @ViewBuilder
    func hashtagView() -> some View {
        WrappingLayout(hSpacing: 5, vSpacing: 5) {
            ForEach($viewModel.hashtags, id: \.id) { hashtag in
                HashtagView(
                    hashtag: hashtag,
                    maxWidth: $hashtagsViewMaxWidth,
                    isFocused: $isHashtagFocused,
                    icon: CommonUIAsset.Image.icExit.swiftUIImage,
                    eventListener: viewModel
                )
                .animation(nil, value: keyboardHeight)
            }
        }
        .padding(.all, 10)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    func createButton() -> some View {
        Text("삼행시 생성하기")
            .font(.suite(size: 16, weight: .regular))
            .foregroundStyle(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 8)
            .background {
                Color.white.opacity(0.2)
                    .clipShape(Capsule())
            }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    
    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()
        
        NewDiaryView(
            isPresented: $isPresented,
            viewModel: .init(),
            selectPhotoBuilder: SelectPhotoPreviewComponent()
        )
    }
}

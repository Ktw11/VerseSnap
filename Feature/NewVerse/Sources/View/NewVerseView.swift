//
//  NewVerseView.swift
//  NewVerse
//
//  Created by 공태웅 on 3/16/25.
//

import SwiftUI
import CommonUI
import SelectPhotoInterface

public struct NewVerseView<SelectPhotoComponent: SelectPhotoBuilder>: View {
    
    // MARK: Lifecycle
    
    public init(
        isPresented: Binding<Bool>,
        viewModel: NewVerseViewModel,
        selectPhotoBuilder: SelectPhotoComponent
    ) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        self.selectPhotoBuilder = selectPhotoBuilder
    }
    
    // MARK: Properties
    
    @Binding var isPresented: Bool
    @Bindable private var viewModel: NewVerseViewModel
    
    @FocusState private var isHashtagFocused: UUID?
    @State private var keyboardHeight: CGFloat = 0
    @State private var hashtagsViewMaxWidth: CGFloat = 0
    @State private var isInputViewPresented: Bool = false
    @State private var isPhotoPickerPresented: Bool = false
    
    private let selectPhotoBuilder: SelectPhotoComponent
    
    public var body: some View {
        ZStack {
            CommonUIAsset.Color.mainBG.swiftUIColor
                .ignoresSafeArea()
            
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
            .background {
                backgroundBlurImage()
            }
            .onTapGesture {
                isHashtagFocused = nil
            }
            .animation(.easeInOut, value: keyboardHeight)
            .transition(.opacity)
            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            
            loadingView()
        }
        .observeKeyboardHeight($keyboardHeight)
        .fullScreenCover(isPresented: $isPhotoPickerPresented) {
            selectPhotoBuilder.build(croppedImage: $viewModel.croppedImage, ratio: viewModel.imageRatio)
                .presentationBackground(CommonUIAsset.Color.mainBG.swiftUIColor)
        }
    }
}

private extension NewVerseView {
    @ViewBuilder
    func backgroundBlurImage() -> some View {
        if let blurImage = viewModel.backgroundBlurImage {
            Image(uiImage: blurImage)
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
    
    @ViewBuilder
    func headerView() -> some View {
        HStack {
            Button(action: {
                isPresented.toggle()
            }, label: {
                CommonUIAsset.Image.icExitBig.swiftUIImage
                    .resizable()
                    .frame(size: 24)
                    .padding(.leading, 27)
            })
            .opacity(viewModel.isVerseGenerated ? 0 : 1.0)
            
            Spacer()
            
            Button(action: {
                viewModel.didTapDone() {
                    isPresented.toggle()
                }
            }, label: {
                Text("완료")
                    .font(.suite(size: 17, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(.trailing, 27)
            })
            .opacity(viewModel.isVerseGenerated ? 1.0 : 0)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func dateView() -> some View {
        Text(viewModel.dateString)
            .font(.suite(size: 20, weight: .bold))
            .foregroundStyle(.white)
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
            .padding(.bottom, 30)
    }
    
    @ViewBuilder
    func imagePickerView() -> some View {
        CommonUIAsset.Color.placeholderBG.swiftUIColor
            .aspectRatio(viewModel.imageRatio, contentMode: .fit)
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.7 }
            .overlay {
                if let uiImage = viewModel.croppedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("사진 선택하기")
                        .foregroundStyle(.white)
                        .font(.suite(size: 15, weight: .regular))
                }
            }
            .overlay(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 120)
                .opacity(viewModel.verse == nil ? 0 : 1.0)
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
        Button(action: {
            viewModel.didTapCreateButton()
        }, label: {
            Text(viewModel.buttonText)
                .font(.suite(size: 16, weight: .regular))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 8)
                .background {
                    Color.white.opacity(0.2)
                        .clipShape(Capsule())
                }
        })
    }
    
    @ViewBuilder
    func loadingView() -> some View {
        let isGenerating: Bool = viewModel.isGeneratingVerse
        let isSaving: Bool = viewModel.isSavingVerseDiary
        
        if isGenerating || isSaving {
            ZStack {
                Color.black.opacity(0.7)
                
                VStack(spacing: 25) {
                    LoadingView()
                 
                    if !isSaving {
                        Text(viewModel.loadingText)
                            .font(.suite(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

#if DEBUG
import PreviewSupport

#Preview {
    @Previewable @State var isPresented: Bool = true
    let verseUseCase: VerseUseCasePreview = {
        let useCase = VerseUseCasePreview.preview
        useCase.verseResult = VerseUseCasePreview.dummy
        return useCase
    }()

    ZStack {
        CommonUIAsset.Color.mainBG.swiftUIColor
            .ignoresSafeArea()

        NewVerseView(
            isPresented: $isPresented,
            viewModel: .init(
                verseUseCase: verseUseCase,
                diaryUseCase: DiaryUseCasePreview.preview,
                appStateUpdator: GlobalStateUpdatorPreview.preview
            ),
            selectPhotoBuilder: SelectPhotoPreviewComponent()
        )
    }
}
#endif

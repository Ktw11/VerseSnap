//
//  SelectPhotoView.swift
//  SelectPhoto
//
//  Created by 공태웅 on 4/9/25.
//

import SwiftUI
import CommonUI

public struct SelectPhotoView: View {
    
    // MARK: Lifecycle
    
    public init(croppedImage: Binding<UIImage?>,viewModel: SelectPhotoViewModel) {
        self._croppedImage = croppedImage
        self.viewModel = viewModel
    }
    
    // MARK: Properties

    @Bindable private var viewModel: SelectPhotoViewModel
    @Binding var croppedImage: UIImage?
    @State var path = NavigationPath()
    @Environment(\.dismiss) private var dismiss
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                NavigationStack(path: $path) {
                    VStack {
                        headerView()
                        
                        photosGridView()
                    }
                    .navigationDestination(for: UIImage.self) { uiImage in
                        ImageCropView(uiImage: uiImage, config: Self.cropConfig(ratio: viewModel.ratio)) { cropped in
                            croppedImage = cropped
                            dismiss()
                        }
                    }
                    .toolbarVisibility(.hidden, for: .navigationBar)
                }
                .tint(Color.white)
            } else {
                loadingView()
            }
        }
        .background(CommonUIAsset.Color.mainBG.swiftUIColor)
    }
}

private extension SelectPhotoView {
    static func cropConfig(ratio: CGFloat) -> ImageCropView.Configuration {
        .init(
            minimumDistanceToSelect: 16,
            minWidth: 100,
            minHeight: 100,
            ratio: ratio
        )
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(alignment: .center) {
            CommonUIAsset.Image.icExitBig.swiftUIImage
                .resizable()
                .frame(size: 24)
                .onTapGesture {
                    dismiss()
                }
                .padding(.leading, 15)
            
            Spacer()
            
            Text("Select photo", bundle: .module)
                .font(.system(size: 17))
                .foregroundStyle(Color.white)
            
            Spacer()

            Color.clear
                .frame(width: 24)
                .padding(.trailing, 15)
        }
        .frame(height: 44)
    }
    
    @ViewBuilder
    func photosGridView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(viewModel.assets, id: \.localIdentifier) { asset in
                    SelectPhotoPickerCell(asset: asset, path: $path)
                        .environment(viewModel)
                }
                
                if !viewModel.isFinished {
                    LoadingView()
                        .padding(.vertical, 10)
                        .frame(alignment: .center)
                        .task {
                            await viewModel.didReachedBottom()
                        }
                }
            }
            .padding(2)
        }
    }
    
    @ViewBuilder
    func loadingView() -> some View {
        LoadingView()
            .frame(alignment: .center)
            .task {
                await viewModel.requestAuthorization()
            }
            .alert(
                String(localized: "Album permission is required.", bundle: .module),
                isPresented: $viewModel.isAuthAlertPresented
            ) {
                Button(String(localized: "Go to Settings", bundle: .module)) {
                    viewModel.openAppSettings()
                }
                
                Button(String(localized: "Cancel", bundle: .module), role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("To select the photo, you need to grant album permission. Please change the permission in Settings.", bundle: .module)
            }
    }
}

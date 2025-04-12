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
    
    public init(viewModel: SelectPhotoViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties

    @Bindable private var viewModel: SelectPhotoViewModel
    @State private var pushCropView = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            if viewModel.isAuthorized {
                VStack {
                    headerView()
                    
                    photosGridView()
                }
            } else {
                loadingView()
            }
        }
    }
}

private extension SelectPhotoView {
    @ViewBuilder
    func headerView() -> some View {
        Text("사진 선택")
            .font(.system(size: 17))
            .foregroundStyle(Color.white)
            .padding(.vertical, 15)
            .frame(alignment: .center)
    }
    
    @ViewBuilder
    func photosGridView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(viewModel.assets, id: \.localIdentifier) { asset in
                    SelectPhotoPickerCell(asset: asset)
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
            .alert("앨범 권한이 필요합니다.", isPresented: $viewModel.isAuthAlertPresented) {
                Button("설정으로 이동") {
                    viewModel.openAppSettings()
                }
                
                Button("취소", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("앱에서 카메라를 사용하려면 카메라 권한이 필요합니다. 설정에서 권한을 변경해주세요.")
            }
    }
}

//
//  DependencyContainer+SelectPhoto.swift
//  App
//
//  Created by 공태웅 on 4/22/25.
//

import Foundation
import SelectPhoto
import SelectPhotoInterface
import Domain
import Photos

extension DependencyContainer {
    @MainActor
    var selectPhotoBuilder: some SelectPhotoBuilder {
        SelectPhotoComponent(
            dependency: SelectPhotoDependency(
                useCase: FetchPhotoAssetUseCaseImpl(
                    authorizer: PHPhotoLibrary.shared(),
                    assetFetcher: PhotoAssetFetcher()
                )
            )
        )
    }
}

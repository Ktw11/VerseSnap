//
//  NewDiaryDependency.swift
//  NewDiary
//
//  Created by 공태웅 on 4/20/25.
//

import Foundation
import SelectPhotoInterface

public struct NewDiaryDependency<SelectPhotoComponent: SelectPhotoBuilder> {
    
    // MARK: Lifecycle
    
    public init(
        selectPhotoBuilder: SelectPhotoComponent
    ) {
        self.selectPhotoBuilder = selectPhotoBuilder
    }
    
    // MARK: Properties

    let selectPhotoBuilder: SelectPhotoComponent
}

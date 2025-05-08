//
//  HashtagEventListener.swift
//  CommonUI
//
//  Created by 공태웅 on 5/8/25.
//

import Foundation

public protocol HashtagEventListener: AnyObject {
    @MainActor
    func didSubmitHashtag(_ hashtag: Hashtag)
    @MainActor
    func removeHashtag(id: UUID)
}

//
//  HashtagEventListener.swift
//  NewDiary
//
//  Created by 공태웅 on 4/4/25.
//

import Foundation

protocol HashtagEventListener {
    @MainActor
    func didSubmitHashtag(_ hashtag: Hashtag)
    @MainActor
    func removeHashtag(id: UUID)
}

//
//  NewVerseViewModel.swift
//  NewVerse
//
//  Created by 공태웅 on 4/4/25.
//

import Foundation
import SwiftUI
import Utils
import Domain

@MainActor
@Observable
public final class NewVerseViewModel {
    
    // MARK: Lifecycle
    
    public init(useCase: VerseUseCase) {
        self.useCase = useCase
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let maxHastagCount: Int = 5
    }
    
    // MARK: Properties
    
    var hashtags: [Hashtag] = [.init(value: "")]
    let dateString: String = dateFormatter.string(from: Date())
    var croppedImage: Image?
    let imageRatio: CGFloat = 0.65
    private let useCase: VerseUseCase
    
    private static var dateFormatter: DateFormatter = .init()
        .dateFormat("yyyy.M.d")
        .locale(Locale.current)
}

extension NewVerseViewModel: HashtagEventListener {
    func didTapCreateButton() {
        // 24시간 내에 글을
        
    }
    
    func didSubmitHashtag(_ hashtag: Hashtag) {
        if hashtag.value.isEmpty {
            guard hashtags.filter({ $0.value.isEmpty }).count > 1 else { return }
            removeHashtag(id: hashtag.id)
        } else {
            guard !hashtagsHasPlaceholder else { return }
            guard hashtags.count < Constants.maxHastagCount else { return }
            hashtags.append(Hashtag(value: ""))
        }
    }
    
    func removeHashtag(id: UUID) {
        if hashtags.count > 1 {
            var filtered = hashtags.filter { $0.id != id }
            if filtered.count < Constants.maxHastagCount && !hashtagsHasPlaceholder {
                filtered.append(Hashtag(value: ""))
            }

            hashtags = filtered
        } else {
            hashtags = [Hashtag(value: "")]
        }
    }
}

private extension NewVerseViewModel {
    var hashtagsHasPlaceholder: Bool {
        hashtags.contains(where: { $0.value.isEmpty })
    }
}

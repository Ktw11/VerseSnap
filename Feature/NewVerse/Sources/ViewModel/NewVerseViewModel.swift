//
//  NewVerseViewModel.swift
//  NewVerse
//
//  Created by 공태웅 on 4/4/25.
//

import Foundation
import SwiftUI
import Utils
import CommonUI
import Domain

@MainActor
@Observable
public final class NewVerseViewModel {
    
    // MARK: Lifecycle
    
    public init(
        verseUseCase: VerseUseCase,
        diaryUseCase: DiaryUseCase,
        appStateUpdator: GlobalAppStateUpdatable
    ) {
        self.verseUseCase = verseUseCase
        self.diaryUseCase = diaryUseCase
        self.appStateUpdator = appStateUpdator
    }
    
    // MARK: Definitions
    
    private enum Constants {
        static let maxHastagCount: Int = 5
        static var loadingText: String {
            let keys: [String.LocalizationValue] = [
                "loadingText1",
                "loadingText2",
                "loadingText3",
                "loadingText4",
                "loadingText5"
            ]
            return keys.randomElement()
                .map { String(localized: $0, bundle: .module) } ?? String(localized: "loadingText1", bundle: .module)
        }
    }
    
    // MARK: Properties
    
    var hashtags: [Hashtag] = [.init(value: "")]
    var croppedImage: UIImage?
    private(set) var isGeneratingVerse: Bool = false
    private(set) var isSavingVerseDiary: Bool = false
    
    var backgroundBlurImage: UIImage? {
        guard generatedVerses != nil else { return nil }
        guard let croppedImage else { return nil }
        return croppedImage
    }
    var isVerseGenerated: Bool {
        generatedVerses != nil
    }
    var loadingText: String {
        Constants.loadingText
    }
    var buttonText: String {
        if generatedVerses == nil {
            String(localized: "Generate", bundle: .module)
        } else {
            String(localized: "Regenerate", bundle: .module)
        }
    }

    var verse: AttributedString? {
        generatedVerses?
            .highlightFirstCharacterOfEachLine(
                highlightedFont: .suite(size: 14, weight: .bold),
                regularFont: .suite(size: 14, weight: .regular)
            )
    }
    
    let dateString: String = Date().yearMonthDayString()
    let imageRatio: CGFloat = 0.65
    
    private var generatedVerses: [String]?

    private let verseUseCase: VerseUseCase
    private let diaryUseCase: DiaryUseCase
    private let appStateUpdator: GlobalAppStateUpdatable
    
    // MARK: Methods
    
    func didTapCreateButton() {
        guard let croppedImage else { return }
        guard !isGeneratingVerse else { return }
        isGeneratingVerse = true
        
        Task { [weak self, verseUseCase] in
            defer { self?.isGeneratingVerse = false }
            
            do {
                let result = try await verseUseCase.generate(image: croppedImage)
                
                if result.verses.isEmpty {
                    throw DomainError.cancelled
                } else {
                    self?.generatedVerses = result.verses
                }
            } catch let error as DomainError {
                self?.handleGenerateDomainError(error)
            } catch {
                let message: String = String(localized: "An error occurred. Please try again.", bundle: .module)
                self?.appStateUpdator.addToast(info: .init(message: message))
            }
        }
    }
    
    func didTapDone(completion: @escaping (() -> Void)) {
        guard let croppedImage, let generatedVerses else { return }
        guard !isSavingVerseDiary else { return }
        isSavingVerseDiary = true
        
        let hashtagValues: [String] = hashtags.map(\.value).filter { !$0.isEmpty }
        Task { [weak self, diaryUseCase] in
            defer {
                self?.isSavingVerseDiary = false
                completion()
            }
            
            do {
                try await diaryUseCase.save(
                    verses: generatedVerses,
                    image: croppedImage,
                    hashtags: hashtagValues
                )
            } catch {
                let message: String = String(localized: "An error occurred. Please try again.", bundle: .module)
                self?.appStateUpdator.addToast(info: .init(message: message))
            }
        }
    }
}

extension NewVerseViewModel: HashtagEventListener {
    public func didSubmitHashtag(_ hashtag: Hashtag) {
        if hashtag.value.isEmpty {
            guard hashtags.filter({ $0.value.isEmpty }).count > 1 else { return }
            removeHashtag(id: hashtag.id)
        } else {
            guard !hashtagsHasPlaceholder else { return }
            guard hashtags.count < Constants.maxHastagCount else { return }
            hashtags.append(Hashtag(value: ""))
        }
    }
    
    public func removeHashtag(id: UUID) {
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
    
    func handleGenerateDomainError(_ error: DomainError) {
        switch error {
        case .exceedDailyLimit:
            let message: String = String(localized: "You have exceeded today’s limit.")
            appStateUpdator.addToast(info: .init(message: message))
        default:
            let message: String = String(localized: "An error occurred. Please try again.")
            appStateUpdator.addToast(info: .init(message: message))
        }
    }
}

private extension NewVerseViewModel {
    var hashtagsHasPlaceholder: Bool {
        hashtags.contains(where: { $0.value.isEmpty })
    }
}

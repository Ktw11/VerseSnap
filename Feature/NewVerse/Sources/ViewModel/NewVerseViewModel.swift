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
        static var loadingText: LocalizedStringKey {
            let defaultText: LocalizedStringKey = "삼행시 뽑는 중.. 🔥"
            
            return [
                defaultText,
                "삼행시 생각 중.. 🔥",
                "머리 싸매는 중.. 🧐",
                "머리 굴리는 중.. 🗿",
                "진지하게 고민 중.. 🤔"
            ].randomElement() ?? defaultText
        }
    }
    
    // MARK: Properties
    
    var hashtags: [Hashtag] = [.init(value: "")]
    var croppedImage: UIImage?
    private(set) var isGeneratingVerse: Bool = false
    private(set) var isSavingVerseDiary: Bool = false
    
    var backgroundBlurImage: UIImage? {
        guard generatedVerse != nil else { return nil }
        guard let croppedImage else { return nil }
        return croppedImage
    }
    var isVerseGenerated: Bool {
        generatedVerse != nil
    }
    var loadingText: LocalizedStringKey {
        Constants.loadingText
    }
    var buttonText: LocalizedStringKey {
        if generatedVerse == nil {
            "삼행시 만들기"
        } else {
            "다시 만들기"
        }
    }
    var verse: AttributedString? {
        generatedVerse?
            .highlightFirstCharacterOfEachLine(
                highlightedFont: .suite(size: 14, weight: .bold),
                regularFont: .suite(size: 14, weight: .regular)
            )
    }
    
    let dateString: String = Date().yearMonthDayString()
    let imageRatio: CGFloat = 0.65
    
    private var generatedVerse: String? = nil

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
                #warning("수정 필요")
                self?.generatedVerse = result.verseInfo.verses.joined()
            } catch let error as DomainError {
                self?.handleGenerateDomainError(error)
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
            }
        }
    }
    
    func didTapDone(completion: @escaping (() -> Void)) {
        guard let croppedImage, let generatedVerse else { return }
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
                    verse: generatedVerse,
                    image: croppedImage,
                    hashtags: hashtagValues
                )
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
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
            appStateUpdator.addToast(info: .init(message: "오늘의 삼행시 횟수 제한을 초과했어요."))
        default:
            appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
        }
    }
}

private extension NewVerseViewModel {
    var hashtagsHasPlaceholder: Bool {
        hashtags.contains(where: { $0.value.isEmpty })
    }
}

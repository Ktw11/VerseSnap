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
    
    public init(useCase: VerseUseCase, appStateUpdator: GlobalAppStateUpdatable) {
        self.useCase = useCase
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
        boldFirstCharacterOfEachLine(from: generatedVerse)
    }
    
    let dateString: String = dateFormatter.string(from: Date())
    let imageRatio: CGFloat = 0.65
    
    private var generatedVerse: String? = nil

    private let useCase: VerseUseCase
    private let appStateUpdator: GlobalAppStateUpdatable
    
    private static var dateFormatter: DateFormatter = .init()
        .dateFormat("yyyy.M.d")
        .locale(Locale.current)
    private static var timeFormatter: DateFormatter = .init()
        .dateFormat("a h:mm")
        .locale(Locale.current)
    
    // MARK: Methods
    
    func didTapCreateButton() {
        guard let croppedImage else { return }
        guard !isGeneratingVerse else { return }
        isGeneratingVerse = true
        
        Task { [weak self, useCase] in
            defer { self?.isGeneratingVerse = false }
            
            do {
                let result = try await useCase.generate(image: croppedImage)
                
                self?.generatedVerse = result.verse
            } catch let error as DomainError {
                self?.handleGenerateDomainError(error)
            } catch {
                self?.appStateUpdator.addToast(info: .init(message: "에러가 발생했습니다. 다시 시도해주세요."))
            }
        }
    }
}

extension NewVerseViewModel: HashtagEventListener {
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
    
    func boldFirstCharacterOfEachLine(from text: String?) -> AttributedString? {
        guard let text else { return nil }
        let lines = text.components(separatedBy: "\n")
        var result = AttributedString()
        
        for (index, line) in lines.enumerated() {
            var attributedLine = AttributedString(line)
            
            let startIndex: AttributedString.Index = attributedLine.startIndex
            let endIndex: AttributedString.Index = attributedLine.index(afterCharacter: startIndex)
            attributedLine[startIndex..<endIndex].font = .suite(size: 14, weight: .bold)
            attributedLine[endIndex...].font = .suite(size: 14, weight: .regular)
            
            result.append(attributedLine)

            if index < lines.count - 1 {
                result.append(AttributedString("\n"))
            }
        }
        
        return result
    }
}

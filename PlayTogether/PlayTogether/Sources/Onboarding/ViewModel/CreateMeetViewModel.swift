//
//  CreateMeetViewModelTest.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/29.
//

import RxSwift
import RxCocoa

final class CreateMeetViewModel {
    
    struct Input {
        var meetingTitleText: Observable<String>
        var introduceText: Observable<String>
    }
    
    struct RegularExpressionInput {
        var meetingTitleText: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var titleTextCheck: Driver<Bool>
    }
    
    struct textEmptyOutput {
        var textFieldEmptyCheck: Driver<Bool>
    }
    
    func regularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.meetingTitleText.map {
            let pattern = "^[0-9a-zㅏ-ㅣA-Zㄱ-ㅎ가-핳\\s]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression)
            else { return false }

            return true
        }.asDriver(onErrorJustReturn: false)
        
        return RegularExpressionOutput(titleTextCheck: output)
    }
    
    func isTextEmpty(input: Input) -> textEmptyOutput {
        let output = Observable.combineLatest(input.meetingTitleText, input.introduceText) { !$0.isEmpty && !$1.isEmpty }
            .asDriver(onErrorJustReturn: false)
        return textEmptyOutput(textFieldEmptyCheck: output)
    }
    
}

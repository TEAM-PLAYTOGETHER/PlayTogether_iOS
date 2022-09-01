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
        var checkMeetingTitle: Observable<Bool>
        var introduceText: Observable<String>
    }
    
    struct RegularExpressionInput {
        var meetingTitleText: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var titleTextCheck: Driver<Bool>
    }
    
    struct nextButtonEnableOutput {
        var nextButtonEnableCheck: Driver<Bool>
    }
    
    func regularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.meetingTitleText.map {
            let pattern = "^[0-9a-zㅏ-ㅣA-Zㄱ-ㅎ가-핳\\s]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression) else { return false }
            return true
        }.asDriver(onErrorJustReturn: false)
        return RegularExpressionOutput(titleTextCheck: output)
    }
    
    func isNextButtonEnable(input: Input) -> nextButtonEnableOutput {
        let output = Observable.combineLatest(input.checkMeetingTitle, input.introduceText) {
            return $0 && !$1.isEmpty
        }.asDriver(onErrorJustReturn: false)
        return nextButtonEnableOutput(nextButtonEnableCheck: output)
    }
}

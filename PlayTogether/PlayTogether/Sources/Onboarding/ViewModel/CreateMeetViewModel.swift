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
    
    struct nextButtonEnableOutput {
        var nextButtonEnableCheck: Driver<Bool>
    }
    
    func isNextButtonEnable(input: Input) -> nextButtonEnableOutput {
        let output = Observable.combineLatest(input.checkMeetingTitle, input.introduceText) {
            return $0 && !$1.isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        return nextButtonEnableOutput(nextButtonEnableCheck: output)
    }
}

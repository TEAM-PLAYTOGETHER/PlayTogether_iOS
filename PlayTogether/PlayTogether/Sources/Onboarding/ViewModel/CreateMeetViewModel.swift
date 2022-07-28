//
//  CreateMeetViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/23.
//

import RxSwift
import RxCocoa

final class CreateMeetViewModel {
    struct input {
        var meetingTitleText: Observable<String>
        var introduceText: Observable<String>
    }
    
    struct RegularExpressionInput {
        var meetingTitleText: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var titleTextCheck: Driver<Bool>
    }
    
    struct ButtonOutput {
        var isEnableNextButton: Driver<Bool>
    }
    
    
    // 정규식 -> Bool
    
    // 버튼 활성화 -> Bool
    
    func regularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.meetingTitleText.map {
            let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$"
            
            guard let _ = $0.range(of: pattern, options: .regularExpression)
            else { return false }
            
            return true
        }.asDriver(onErrorJustReturn: false)
        
        return RegularExpressionOutput(titleTextCheck: output)
    }
    
//    func checkNextButtonStatus(input: Input) -> Output {
//        let isEnableNextButton = Observable.combineLatest(input.meetingTitleCheck, input.introduceTextCheck) { $0 && $1 }
//            .asDriver(onErrorJustReturn: false)
//        return Output(isEnableNextButton: isEnableNextButton)
//    }
}

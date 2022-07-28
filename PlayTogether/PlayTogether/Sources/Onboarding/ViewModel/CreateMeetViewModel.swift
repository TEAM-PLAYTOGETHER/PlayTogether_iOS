//
//  CreateMeetViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/23.
//

import RxSwift
import RxCocoa

final class CreateMeetViewModel {
    
    let input: Input

    private let titleText: BehaviorSubject<String>
    private let introduceText: BehaviorSubject<String>
    
    struct Input {
        var meetingTitleText: Observable<String>
        var introduceText: Observable<String>
    }
    
    struct Output {
        var titleTextCheck: Driver<Bool>
        var isEnableNextButton: Driver<Bool>
    }
    
    init() {
        self.input = Input(meetingTitleText: titleText.asObserver(), introduceText: introduceText.asObserver())
    }
    
    // 정규식 -> Bool
    
    // 버튼 활성화 -> Bool
    
    func vailableText() {
        
    }
    
    func checkNextButtonStatus(input: Input) -> Output {
        let isEnableNextButton = Observable.combineLatest(input.meetingTitleCheck, input.introduceTextCheck) { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        return Output(isEnableNextButton: isEnableNextButton)
    }
}

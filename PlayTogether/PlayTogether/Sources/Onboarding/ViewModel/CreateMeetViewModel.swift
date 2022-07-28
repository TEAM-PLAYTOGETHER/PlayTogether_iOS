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
    let output: Output
    
    struct Input {
        var meetingTitleText: AnyObserver<String?>
        var introduceText: AnyObserver<String?>
    }
    
    struct Output {
        var isValidText: Driver<Bool>
        var isEnableNextButton: Driver<Bool>
    }
    
    init() {
        let titleText = BehaviorSubject<String?>(value: nil)
        let introduceText = BehaviorSubject<String?>(value: nil)
        
        let isValidText = titleText
            .map(isValidText)
            .asDriver(onErrorJustReturn: false)
        
        let isEnableNextButton = Observable.combineLatest(titleText, introduceText)
            .map(isEnableNextButton)
            .asDriver(onErrorJustReturn: false)
        
        self.input = Input(meetingTitleText: titleText.asObserver(), introduceText: introduceText.asObserver())
        self.output = Output(isValidText: isValidText, isEnableNextButton: isEnableNextButton)
    }
}

private func isValidText(title: String?) -> Bool {
    let pattern = "^[0-9a-zA-Z가-핳\\s]*$" // 이거 끝내고 커밋,
    guard let title = title, !title.isEmpty else { return false }
    guard let _ = title.range(of: pattern, options: .regularExpression) else { return false }
    return true
}

private func isEnableNextButton(title: String?, introduce: String?) -> Bool {
    guard let title = title, let introduce = introduce else { return false }
    return isValidText(title: title) && !title.isEmpty && !introduce.isEmpty
}

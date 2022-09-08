//
//  CheckTermsServiceViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/04.
//

import RxSwift
import RxCocoa

final class CheckTermsServiceViewModel {
    
    var ageCheck = BehaviorSubject<Bool>(value: false)
    var termsCheck = BehaviorSubject<Bool>(value: false)
    var privacyCheck = BehaviorSubject<Bool>(value: false)
    var marketingCheck = BehaviorSubject<Bool>(value: false)
    
    struct AllCheckDriverOutput {
        var allCheck: Driver<Bool>
    }
    
    struct ConfirmButtonDriverOutput {
        var confirmButtonState: Driver<Bool>
    }
    
    func buttonAllStateCheck() -> AllCheckDriverOutput {
        let output = Observable.combineLatest(
            ageCheck.asObservable(),
            termsCheck.asObservable(),
            privacyCheck.asObservable(),
            marketingCheck.asObservable()
        ) {
            return $0 && $1 && $2 && $3
        }.asDriver(onErrorJustReturn: false)
        return AllCheckDriverOutput(allCheck: output)
    }
    
    func confirmButtonEnalbeCheck() -> ConfirmButtonDriverOutput {
        let output = Observable.combineLatest(
            ageCheck.asObservable(),
            termsCheck.asObservable(),
            privacyCheck.asObservable()
        ) {
            return $0 && $1 && $2
        }.asDriver(onErrorJustReturn: false)
        return ConfirmButtonDriverOutput(confirmButtonState: output)
    }
}

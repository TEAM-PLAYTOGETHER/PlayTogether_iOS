//
//  InvatationCodeViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/02.
//

import RxSwift
import RxCocoa

final class InvitationCodeViewModel {
    
    struct RegularExpressionInput {
        var inviteCodeText: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var inviteCodeCheck: Driver<Bool>
    }
    
    func regularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.inviteCodeText.map {
            let pattern = "^[A-Z]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression) else { return false }

            return true
        }.asDriver(onErrorJustReturn: false)
        
        return RegularExpressionOutput(inviteCodeCheck: output)
    }
}

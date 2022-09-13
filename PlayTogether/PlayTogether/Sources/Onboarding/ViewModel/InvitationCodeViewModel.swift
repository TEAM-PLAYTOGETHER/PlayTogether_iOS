//
//  InvatationCodeViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/02.
//

import RxSwift
import RxCocoa
import Moya

final class InvitationCodeViewModel {
    private lazy var disposeBag = DisposeBag()
    
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
    
    func registerCrew(_ code: String, completion: @escaping (registerCrewResponse) -> Void) {
        let provider = MoyaProvider<SelfIntroduceService>()
        
        provider.rx.request(.registerCrewRequest(crewCode: code))
            .subscribe { result in
                switch result {
                case .success(let response):
                    // TODO: Status code: 500이라 상황 알아보기
                    print(response)
                    guard let responseData = try? response.map(registerCrewResponse.self) else { return }
                    completion(responseData)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

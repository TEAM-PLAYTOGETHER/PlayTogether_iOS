//
//  LoginViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/23.
//

import RxSwift
import Moya

final class LoginViewModel {
    private lazy var disposeBag = DisposeBag()
    
    struct loginTokenInput {
        var accessToken: String
        var fcmToken: String
    }
    
    func tryLogin(_ input: loginTokenInput, completion: @escaping (LoginResponse) -> Void) {
        let provider = MoyaProvider<LoginService>()
        provider.rx.request(.kakaoLoginReuest(accessToken: input.accessToken,
                                              fcmToken: input.fcmToken))
        .subscribe { result in
            switch result {
            case .success(let response):
                let responseData = try? response.map(LoginResponse.self)
                guard let userInfo = responseData else { return }
                completion(userInfo)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}

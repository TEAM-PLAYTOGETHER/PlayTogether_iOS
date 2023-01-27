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
    private let provider = MoyaProvider<LoginService>()
    
    struct loginTokenInput {
        var accessToken: String
        var fcmToken: String
    }
    
    func socialLoginRequest(
        input: loginTokenInput,
        type: SocialLoginType,
        completion: @escaping (LoginResponse) -> Void
    ) {
        switch type {
        case .KakaoLogin:
            provider.rx.request(.kakaoLoginReuest(
                accessToken: input.accessToken,
                fcmToken: input.fcmToken
            )).subscribe { result in
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
            
        case .AppleLogin:
            provider.rx.request(.appleLoginReuset(
                accessToken: input.accessToken,
                fcmToken: input.fcmToken
            )).subscribe { result in
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
    
}

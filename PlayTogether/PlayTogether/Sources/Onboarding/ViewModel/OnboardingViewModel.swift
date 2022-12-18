//
//  OnboardingViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import RxSwift
import Moya

struct OnboardingViewModel {
    private lazy var disposeBag = DisposeBag()
    private let provider = MoyaProvider<OnboardingService>()
    
    struct UserJWTToken {
        var token: String
    }
    
    func getCrewList(jwt: UserJWTToken, completion: @escaping (CrewLists) -> Void) {
        provider.rx.request(.getCrewInfo(
            jwtToken: jwt.token
        ))
        .subscribe{ result in
            switch result {
            case .success(let response):
                guard let responseData = try? response.map(CrewLists.self) else { return }
                completion(responseData)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}

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
        var token: Observable<String>
    }
    
    func getCrewList() {
        
    }
}

//
//  InputGenderBirthYearViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/07.
//

import RxSwift
import Moya
import RxMoya

final class InputGenderBirthYearViewModel {
    private lazy var disposeBag = DisposeBag()
    
    struct updateUserInfoInput {
        var userGender: String
        var userBirthYear: Int
    }
    
    func updateUserInfo(_ input: updateUserInfoInput, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<UpdateUserInfoService>()
        
        provider.rx.request(.updateUserInfoRequest(gender: input.userGender,
                                                   birthYear: input.userBirthYear))
        .subscribe { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                statusCode == 200 ? completion(true) : completion(false)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}

//
//  SelfIntroduceViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

import RxSwift
import RxCocoa
import RxRelay
import Moya
import RxMoya

final class SelfIntroduceViewModel {
    private lazy var disposeBag = DisposeBag()
    
    struct checkNicknameInput {
        var crewID: Int
        var nickname: Observable<String>
    }
    
    func checkNickname(_ crewId: Int, _ nickName: String, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<SelfIntroduceService>()
        provider.rx.request(.existingNicknameRequset(crewID: crewId, Nickname: nickName))
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

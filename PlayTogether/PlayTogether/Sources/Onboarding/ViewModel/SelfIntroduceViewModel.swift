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
    private let provider = MoyaProvider<SelfIntroduceService>()
    
    struct checkNicknameInput {
        var crewID: Int
        var nickname: Observable<String>
    }
    
    func checkNickname(_ crewId: Int, _ nickName: String, completion: @escaping (Bool) -> Void) {
        provider.rx.request(.existingNicknameRequset(crewID: crewId, Nickname: nickName))
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response.statusCode == 200)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func registerUserProfile(
        _ crewId: Int,
        _ nickName: String,
        _ description: String,
        _ firstSubway: String? = nil,
        _ secondSubway: String? = nil
    ) -> Single<Response> {
        let singleResponse: Single<Response> = provider.rx.request(
            .registerUserSubwayStations(
                crewID: crewId,
                nickName: nickName,
                description: description,
                firstSubway: firstSubway,
                secondSubway: secondSubway)
        )
        return singleResponse
    }
}

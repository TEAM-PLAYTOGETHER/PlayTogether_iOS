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
        _ firstSubway: String,
        _ secondSubway: String? = nil,
        completion: @escaping (Bool) -> Void) {
        provider.rx.request(
            .registerUserSubwayStations(
                crewID: crewId,
                nickName: nickName,
                description: description,
                firstSubway: firstSubway,
                secondSubway: secondSubway)
        ).subscribe { result in
            switch result {
            case .success(let response):
                guard let responseData = try? response.map(SelfIntroduceResponse.self)
                else { return }
                completion(responseData.status == 200)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
}

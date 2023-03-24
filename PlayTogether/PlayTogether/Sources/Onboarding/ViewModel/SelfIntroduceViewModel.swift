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
    
    struct CheckNicknameInput {
        var nickname: String
    }
    
    func checkNickname(_ input: CheckNicknameInput) -> Driver<Bool> {
        return provider.rx.request(.existingNicknameRequset(
            crewID: OnboardingDataModel.shared.crewId ?? -1,
            Nickname: input.nickname
        ))
        .map { response in
            return response.statusCode == 200
        }
        .asDriver(onErrorJustReturn: false)
    }
    
    func registerUserProfile(
        _ nickName: String,
        _ description: String,
        _ firstSubway: String? = nil,
        _ secondSubway: String? = nil
    ) -> Observable<SelfIntroduceResponse> {
        return provider.rx.request(
            .registerUserSubwayStations(
                crewID: OnboardingDataModel.shared.crewId ?? -1,
                nickName: nickName,
                description: description,
                firstSubway: firstSubway,
                secondSubway: secondSubway
            ))
        .asObservable()
        .map(SelfIntroduceResponse.self)
    }
}

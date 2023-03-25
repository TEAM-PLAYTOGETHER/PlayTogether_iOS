//
//  SelfIntroduceViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

import RxSwift
import RxCocoa
import Moya
import RxMoya

final class SelfIntroduceViewModel {
    private lazy var disposeBag = DisposeBag()
    private let provider = MoyaProvider<SelfIntroduceService>()
    
    struct Input {
        var tapNickNameButton: ControlEvent<Void>
        var tapNextButton: ControlEvent<Void>
        var nickNameInput: Observable<String>
        var descriptionInput: Observable<String>
        var subwayInput: Observable<[String?]>
    }

    struct Output {
        var checkNickNameOutput: Observable<Bool>
        var registUserProfileOutput: Observable<SelfIntroduceResponse>
    }

    func transform(_ input: Input) -> Output {
        let isEnableNickName = input.tapNickNameButton
            .withLatestFrom(input.nickNameInput)
            .withUnretained(self)
            .flatMap { owner, nickName in
                owner.provider.rx.request(.existingNicknameRequset(
                    crewID: OnboardingDataModel.shared.crewId ?? -1,
                    nickName: nickName
                ))
            }
            .map { $0.statusCode == 200 }
            .asObservable()

        let isSuccessRegistUserProfile = input.tapNextButton
            .flatMap {
                Observable.combineLatest(
                    input.nickNameInput,
                    input.descriptionInput,
                    input.subwayInput
                ).asObservable()
            }
            .withUnretained(self)
            .flatMap { owner, combineValues in
                owner.provider.rx.request(.registerUserSubwayStations(
                    crewID: OnboardingDataModel.shared.crewId ?? -1,
                    nickName: combineValues.0,
                    description: combineValues.1,
                    firstSubway: combineValues.2[0],
                    secondSubway: combineValues.2[1]
                ))
            }
            .map(SelfIntroduceResponse.self)
            .asObservable()

        return .init(
            checkNickNameOutput: isEnableNickName,
            registUserProfileOutput: isSuccessRegistUserProfile
        )
    }
}

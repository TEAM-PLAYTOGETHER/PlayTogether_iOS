//
//  SelfIntroduceViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

import RxSwift
import RxRelay
import Moya
import RxMoya

final class SelfIntroduceViewModel {
    private lazy var disposeBag = DisposeBag()
    var subwayStationList = BehaviorSubject<[StationResponse?]>.init(value: [])
    var stationNameRelay = BehaviorRelay<String>.init(value: "")
    
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
            }.disposed(by: disposeBag)
    }
    
    // TODO: 지하철 역 파라미터, String 변환
    func fetchSubwayStationList(completion: @escaping ([StationsInfo?]) -> Void ) {
        let provider = MoyaProvider<SelfIntroduceService>()
        
        provider.rx.request(.searchStationRequeset(stationName: stationNameRelay.value, type: "json", serviceKey: APIConstants.subwayServiceKey))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(StationResponse.self)
                    guard let data = responseData?.response.body.items.item else { return }
                    completion(data)
                    
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }.disposed(by: disposeBag)
    }
    
}

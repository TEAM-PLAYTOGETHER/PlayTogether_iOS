//
//  AddSubwayStationViewModel.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/18.
//

import RxSwift
import RxCocoa
import RxRelay
import Moya
import RxMoya

final class AddSubwayStationViewModel {
    private lazy var disposeBag = DisposeBag()
    var subwayStationList = BehaviorSubject<[StationResponse?]>.init(value: [])
    var stationNameRelay = BehaviorRelay<String>.init(value: "")
    
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
            }
            .disposed(by: disposeBag)
    }
}

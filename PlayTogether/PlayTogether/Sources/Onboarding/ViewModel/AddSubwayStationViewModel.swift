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
import Foundation

final class AddSubwayStationViewModel {
    private lazy var disposeBag = DisposeBag()
//    var subwayStationList = BehaviorSubject<SubwayStationResponse?]>.init(value: [])
    var stationNameRelay = BehaviorRelay<String>.init(value: "")
    
    struct RegularExpressionInput {
        var SubwayStationTitle: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var SubwayStationTitleCheck: Driver<Bool>
    }
    
    func RegularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.SubwayStationTitle.map {
            let pattern = "^[ㄱ-ㅎ가-핳0-9\\s]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression) else { return false }
            
            return true
        }.asDriver(onErrorJustReturn: false)
        
        return RegularExpressionOutput(SubwayStationTitleCheck: output)
    }
    
    // TODO: 지하철 역 파라미터, String 변환
    func fetchSubwayStationList(completion: @escaping ([SubwayList]) -> Void) {
        let provider = MoyaProvider<SelfIntroduceService>()
        provider.rx.request(.searchStationRequeset)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(SubwayStationResponse.self)
                    print(responseData)
                    
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

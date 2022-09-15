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
import CloudKit

final class AddSubwayStationViewModel {
    private lazy var disposeBag = DisposeBag()
    var subwayStationList = PublishSubject<[String]>()
    private var subwayStationDataList = [String]()
    
    struct RegularExpressionInput {
        var SubwayStationTitle: Observable<String>
    }
    
    struct RegularExpressionOutput {
        var SubwayStationTitleCheck: Driver<Bool>
    }
    
    init() {
        fetchSubwayStationList()
    }
    
    func RegularExpressionCheck(input: RegularExpressionInput) -> RegularExpressionOutput {
        let output = input.SubwayStationTitle.map {
            let pattern = "^[ㄱ-ㅎ가-핳0-9\\s]*$"
            guard let _ = $0.range(of: pattern, options: .regularExpression) else { return false }
            
            return true
        }.asDriver(onErrorJustReturn: false)
        
        return RegularExpressionOutput(SubwayStationTitleCheck: output)
    }
    
    func fetchSubwayStationList() {
        let provider = MoyaProvider<SelfIntroduceService>()
        provider.rx.request(.searchStationRequeset)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(SubwayStationResponse.self)
                    guard let data = responseData?.searchSTNBySubwayLineInfo.row else { return }
                    for index in 0..<data.count {
                        self?.subwayStationDataList.append(data[index].stationName)
                    }
                    
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func filterSubwayStationList(input: RegularExpressionInput) {
        input.SubwayStationTitle
            .subscribe(onNext: { [weak self] in
                let text = $0.lowercased()
                let filterData = self?.subwayStationDataList.filter { $0.lowercased().hasPrefix(text) }
                self?.subwayStationList.onNext(filterData!.uniqued())
            })
            .disposed(by: disposeBag)
    }
}

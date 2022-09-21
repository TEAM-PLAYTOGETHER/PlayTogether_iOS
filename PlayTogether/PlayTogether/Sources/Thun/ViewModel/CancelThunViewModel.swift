//
//  CancelSubmittedViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/22.
//

import Foundation
import Moya
import RxSwift

final class CancelThunViewModel {
    private lazy var disposeBag = DisposeBag()
    
    func postCancelThun(lightId: Int, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<CancelThunService>()
        provider.rx.request(.cancelThunRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(CancelThunResponse.self)
                    guard let data = responseData?.success else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func postReportThun(lightId: Int, report: String, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<ReportThunService>()
        provider.rx.request(.reportThunRequest(lightId: lightId, report: report))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(CancelThunResponse.self)
                    guard let data = responseData?.success else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

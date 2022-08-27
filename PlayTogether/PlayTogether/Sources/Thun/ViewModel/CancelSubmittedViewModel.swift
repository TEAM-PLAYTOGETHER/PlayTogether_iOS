//
//  CancelSubmittedViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/22.
//

import Foundation
import Moya
import RxSwift

final class CancelSubmittedViewModel {
    private lazy var disposeBag = DisposeBag()
    
    func postCancelSubmittedButton(lightId: Int, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<CancelSubmittedService>()
        provider.rx.request(.detailThunCancelSubmittedRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(CancelSubmittedResponse.self)
                    guard let data = responseData?.success else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

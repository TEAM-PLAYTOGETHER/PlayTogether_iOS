//
//  DeleteThunViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/28.
//

import Foundation
import Moya
import RxSwift

final class DeleteThunViewModel {
    private lazy var disposeBag = DisposeBag()
    
    func postDeleteThun(lightId: Int, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<DeleteThunService>()
        provider.rx.request(.deleteThunRequest(lightId: lightId))
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


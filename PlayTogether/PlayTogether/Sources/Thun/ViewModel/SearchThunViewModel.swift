//
//  SearchThunViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/04.
//

import RxSwift
import Moya
import RxCocoa

final class SearchThunViewModel {
    private lazy var disposeBag = DisposeBag()
    var thunList = BehaviorSubject(value: [ThunResponseList]())
    var emptyThunList = BehaviorSubject<Bool>(value: false)

    func searchThunData(_ search: String,_ category: String, completion: @escaping ([ThunResponseList]) -> Void) {
        let provider = MoyaProvider<SearchThunService>()
        provider.rx.request(.searchThunRequest(search: search, category: category))
            .subscribe { result in
                switch result {
                case .success(let response):
                    let responseData = try? response.map(ThunResponse.self)
                    guard let data = responseData?.data.lightData else { return }
                    completion(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

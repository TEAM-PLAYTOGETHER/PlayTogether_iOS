//
//  HomeViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

import UIKit
import RxSwift
import Moya
import RxMoya

final class HomeViewModel {
    private lazy var disposeBag = DisposeBag()
    
    func fetchHotThunList(completion: @escaping (Observable<[HomeResponseList?]>) -> Void) {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.hotThunRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    completion(Observable<[HomeResponseList?]>.of(data))
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchNewThunList(completion: @escaping (Observable<[HomeResponseList?]>) -> Void) {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.newThunRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    completion(Observable<[HomeResponseList?]>.of(data))
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

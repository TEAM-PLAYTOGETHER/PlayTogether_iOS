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
    var hotThunList = BehaviorSubject<[HomeResponseList?]>.init(value: Array.init())
    var newThunList = BehaviorSubject<[HomeResponseList?]>.init(value: Array.init())
    
    init () {
        self.fetchHotThunList { self.hotThunList.onNext($0) }
        self.fetchNewThunList { self.newThunList.onNext($0) }
    }
    
    func fetchHotThunList(completion: @escaping ([HomeResponseList?]) -> Void) {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.hotThunRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchNewThunList(completion: @escaping ([HomeResponseList?]) -> Void) {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.newThunRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

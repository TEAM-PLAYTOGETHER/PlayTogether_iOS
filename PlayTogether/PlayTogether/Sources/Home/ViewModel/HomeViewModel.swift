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
    var hotThunList = PublishSubject<[HomeResponseList?]>()
    var isEmptyHotThun = BehaviorSubject<Bool>(value: false)
    var newThunList = PublishSubject<[HomeResponseList?]>()
    var isEmptyNewThun = BehaviorSubject<Bool>(value: false)
    
    init () {
        fetchHotThunList()
        fetchNewThunList()
    }
    
    func fetchHotThunList() {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.hotThunRequest)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    self?.hotThunList.onNext(data)
                    if data.isEmpty { self?.isEmptyHotThun.onNext(true) }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchNewThunList() {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.newThunRequest)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    self?.newThunList.onNext(data)
                    if data.isEmpty { self?.isEmptyNewThun.onNext(true) }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

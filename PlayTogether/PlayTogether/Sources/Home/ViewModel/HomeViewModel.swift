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
    private letAPIConstants.swift disposeBag = DisposeBag()
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
                    data.isEmpty ? self?.isEmptyHotThun.onNext(true) : self?.hotThunList.onNext(data)
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
                    data.isEmpty ? self?.isEmptyNewThun.onNext(true) : self?.newThunList.onNext(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

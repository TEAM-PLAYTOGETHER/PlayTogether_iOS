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
    var crewList = [CrewResponse]()
    var hotThunList = PublishSubject<[HomeResponseList?]>()
    var isEmptyHotThun = BehaviorSubject<Bool>(value: false)
    var newThunList = PublishSubject<[HomeResponseList?]>()
    var isEmptyNewThun = BehaviorSubject<Bool>(value: false)
    
    init () {
        fetchCrewList()
        fetchHotThunList()
        fetchNewThunList()
    }
    
    func fetchCrewList() {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.crewListRequest)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(CrewListResponse.self)
                    guard let data = responseData?.data else { return }
                    self?.crewList = data.crewList
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchHotThunList() {
        let provider = MoyaProvider<HomeService>()
        provider.rx.request(.hotThunRequest)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(HomeResponse.self)
                    guard let data = responseData?.data else { return }
                    let isDataEmpty = data.isEmpty
                    self?.isEmptyHotThun.onNext(isDataEmpty)
                    if !isDataEmpty { self?.hotThunList.onNext(data)}
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
                    let isDataEmpty = data.isEmpty
                    self?.isEmptyNewThun.onNext(isDataEmpty)
                    if !isDataEmpty { self?.newThunList.onNext(data)}
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

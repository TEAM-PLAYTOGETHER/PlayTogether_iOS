//
//  Thun.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/24.
//

import UIKit
import RxSwift
import Moya
import RxMoya

final class ThunViewModel {
    private lazy var disposeBag = DisposeBag()
    
    var submittedThunList = BehaviorSubject<[ThunResponseList?]>.init(value: Array.init())
    var openedThunList = BehaviorSubject<[ThunResponseList?]>.init(value: Array.init())
    var likedThunList = BehaviorSubject<[ThunResponseList?]>.init(value: Array.init())
    
    init () {
        self.fetchSubmittedThunList { self.submittedThunList.onNext($0) }
        self.fetchOpenedThunList { self.openedThunList.onNext($0) }
        self.fetchLikedThunList { self.likedThunList.onNext($0) }
    }
    
    func fetchSubmittedThunList(completion: @escaping([ThunResponseList?]) -> Void) {
        let provider = MoyaProvider<ThunService>()
        provider.rx.request(.submittedRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try?
                    response.map(ThunResponse.self)
                    guard let data = responseData?.data.lightData else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func fetchOpenedThunList(completion: @escaping([ThunResponseList?]) -> Void) {
        let provider = MoyaProvider<ThunService>()
        provider.rx.request(.openedRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try?
                    response.map(ThunResponse.self)
                    guard let data = responseData?.data.lightData else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchLikedThunList(completion: @escaping([ThunResponseList?]) -> Void) {
        let provider = MoyaProvider<ThunService>()
        provider.rx.request(.likedRequest)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try?
                    response.map(ThunResponse.self)
                    guard let data = responseData?.data.lightData else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

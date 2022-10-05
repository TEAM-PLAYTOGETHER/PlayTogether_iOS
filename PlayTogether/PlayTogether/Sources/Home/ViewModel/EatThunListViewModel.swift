//
//  Thun.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/24.
//

import UIKit
import RxSwift
import Moya
import RxRelay

final class EatThunListViewModel {
    private lazy var disposeBag = DisposeBag()
    var currentPageCount = 1
    let maxSize = 5
    var isLoading = false

    let fetchMoreDatas = PublishSubject<Void>()
    var isEmptyThun = BehaviorSubject<Bool>(value: false)
    var eatGoDoThunList = BehaviorRelay<[ThunResponseList?]>.init(value: Array.init())
    
    init () {
        paginationBind()
    }
    
    private func paginationBind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchThunData(page: self.currentPageCount)
        }
        .disposed(by: disposeBag)
    }  
    
    func fetchThunData(page: Int) {
        if isLoading { return }
        
        isLoading = true
        
        fetchThunList(pageSize: maxSize, curpage: page, category: "먹을래", sort: "createdAt") { response in
            if self.currentPageCount == 1 {
                self.handleThunData(data: response)
                self.isLoading = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.handleThunData(data: response)
                    self.isLoading = false
                }
            }
        }
    }

    func handleThunData(data: [ThunResponseList]) {
        if self.currentPageCount == 1, !data.isEmpty {
            self.eatGoDoThunList.accept(data)
        } else if !data.isEmpty {
            let oldData = self.eatGoDoThunList.value
            self.eatGoDoThunList.accept(oldData + data)
        }
        currentPageCount += 1
    }
    
    func fetchThunList(pageSize: Int, curpage: Int, category: String, sort: String, completion: @escaping([ThunResponseList]) -> Void) {
        let provider = MoyaProvider<ThunListService>()
        provider.rx.request(.eatGoDoRequest(pageSize: maxSize, curpage: currentPageCount, category: category, sort: sort))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try?
                    response.map(ThunResponse.self)
                    guard let data = responseData?.data else { return }
                    if data.offset == 0 && data.totalCount == 0 {
                        self.isEmptyThun.onNext(true)
                    } else if data.totalCount != 0 {
                        completion(data.lightData)
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}


//
//  Thun.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/24.
//

import UIKit
import RxSwift
import Moya

final class OpenedThunViewModel {
    private lazy var disposeBag = DisposeBag()
    private var currentPageCount = 1
    private var maxSize = 5
    private var isLoading = false

    let fetchMoreDatas = PublishSubject<Void>()
    var isEmptyThun = BehaviorSubject<Bool>(value: false)
    var openedThunList = BehaviorSubject<[ThunResponseList?]>.init(value: Array.init())
    
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
        
        fetchOpenedThunList(pageSize: maxSize, curpage: page) { response in
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
        if currentPageCount == 1, !data.isEmpty {
            openedThunList.onNext(data)
        } else if !data.isEmpty {
            guard let oldData = try? openedThunList.value() else { return }
            openedThunList.onNext(oldData + data)
        }
        currentPageCount += 1
    }
    
    func fetchOpenedThunList(pageSize: Int, curpage: Int, completion: @escaping([ThunResponseList]) -> Void) {
        let provider = MoyaProvider<ThunService>()
        provider.rx.request(.openedRequest(pageSize: maxSize, curpage: currentPageCount))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try?
                    response.map(ThunResponse.self)
                    guard let data = responseData?.data else { return }
                    if data.offset == 0 && data.totalCount == 0 {
                        self.isEmptyThun.onNext(true)
                    } else {
                        if data.totalCount != 0 { completion(data.lightData) }
                    }
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}


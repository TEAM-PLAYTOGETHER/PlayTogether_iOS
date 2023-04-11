//
//  SearchThunViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/04.
//

import RxSwift
import Moya
import RxCocoa
import UIKit

final class SearchThunViewModel {
    private lazy var disposeBag = DisposeBag()
    var currentPageCount = 1
    var maxSize = 5
    var isLoading = false
    var query = ""
    var category = ""

    let fetchMoreDatas = PublishSubject<Void>()
    var isEmptyThun = BehaviorSubject<Bool>(value: false)
    var thunList = BehaviorSubject(value: [ThunResponseList]())
    
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
        
        fetchSearchThunList(pageSize: maxSize, curpage: page, query, category) { response in
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
            thunList.onNext(data)
        } else if !data.isEmpty {
            guard let oldData = try? thunList.value() else { return }
            self.thunList.onNext(oldData + data)
        }
        currentPageCount += 1
    }
    
    func fetchSearchThunList(pageSize: Int, curpage: Int,_ search: String,_ category: String, completion: @escaping ([ThunResponseList]) -> Void) {
        let provider = MoyaProvider<SearchThunService>()
        provider.rx.request(.searchThunRequest(pageSize: pageSize, curpage: curpage, search: search, category: category))
            .subscribe { result in
                switch result {
                case .success(let response):
                    let responseData = try? response.map(ThunResponse.self)
                    guard let data = responseData?.data else { return }
                    if data.offset == 0 && data.totalCount == 0 {
                        self.isEmptyThun.onNext(true)
                    } else {
                        if data.totalCount != 0 {
                            self.isEmptyThun.onNext(false)
                            completion(data.lightData) }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

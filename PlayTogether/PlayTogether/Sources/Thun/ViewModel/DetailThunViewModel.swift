//
//  DetailThunViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/15.
//

import Foundation
import Moya
import RxSwift

final class DetailThunViewModel {
    private lazy var disposeBag = DisposeBag()
    
    func getDetailThunList(lightId: Int, completion: @escaping ([DetailThunList]) -> Void) {
        let provider = MoyaProvider<DetailThunService>()
        provider.rx.request(.detailThunRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(DetailThunResponse.self)
                          guard let data = responseData?.data else { return }
                          completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getMemberList(lightId: Int, completion: @escaping([Member]) -> Void) {
        let provider = MoyaProvider<DetailThunService>()
        provider.rx.request(.detailThunRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(DetailThunResponse.self)
                    guard let data = responseData?.data[0].members else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getImageList(lightId: Int, completion: @escaping(String) -> Void) {
        let provider = MoyaProvider<DetailThunService>()
        provider.rx.request(.detailThunRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(DetailThunResponse.self)
                    guard let data = responseData?.data[0].image else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}


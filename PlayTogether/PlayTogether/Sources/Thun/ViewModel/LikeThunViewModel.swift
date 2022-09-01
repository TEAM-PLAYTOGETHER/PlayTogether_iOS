//
//  LikeThunViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/28.
//

import Foundation
import Moya
import RxSwift

final class LikeThunViewModel {
    private lazy var disposeBag = DisposeBag()
    var isRemovedLike = false
    
    func postLikeThun(lightId: Int, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<LikeThunService>()
        provider.rx.request(.likeThunRequest(lightId: lightId))
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(CancelThunResponse.self)
                    guard let data = responseData?.message else { return }
                    let isRemoved = data == "찜하기가 완료되었습니다." ? false : true
                    self?.isRemovedLike = isRemoved
                    completion(isRemoved)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getExistLikeThun(lightId: Int, completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<ExistLikeThunService>()
        provider.rx.request(.existLikeThunRequest(lightId: lightId))
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(ExistLikeThunResponse.self)
                    guard let data = responseData?.data else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

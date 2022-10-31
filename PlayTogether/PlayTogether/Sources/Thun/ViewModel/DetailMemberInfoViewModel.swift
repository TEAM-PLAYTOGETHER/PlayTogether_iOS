//
//  SearchThunViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/04.
//

import RxSwift
import Moya
import RxCocoa

final class DetailMemberInfoViewModel {
    private lazy var disposeBag = DisposeBag()
    
    func detailMemberInfo(memberId: Int, completion: @escaping (DataClass) -> Void) {
        let provider = MoyaProvider<DetailMemberInfoService>()
        provider.rx.request(.detailMemberInfoRequest(memberId: memberId))
            .subscribe { result in
                switch result {
                case .success(let response):
                    let responseData = try? response.map(DetailMemberInfoResponse.self)
                    guard let data = responseData?.data else { return }
                    completion(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}


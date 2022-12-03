//
//  SettingViewModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/10/27.
//

import Foundation
import RxSwift
import Moya

final class SettingViewModel {
    private lazy var disposeBag = DisposeBag()
    
    let firstMenuList = ["알림 설정", "계정 관리"]
    let secondMenuList = ["이용 가이드", "정책 및 약관", "버전 정보", "개발자 정보"]
    let thirdMenuList = ["로그아웃"]
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        let provider = MoyaProvider<DeleteAccountService>()
        provider.rx.request(.deleteAccount)
            .subscribe { result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(CancelThunResponse.self)
                    guard let data = responseData?.success else { return }
                    completion(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

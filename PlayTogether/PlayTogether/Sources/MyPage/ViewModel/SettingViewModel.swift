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
    
    let firstSectionList = ["알림 설정", "계정 관리"]
    let secondSectionList = ["이용 가이드", "정책 및 약관", "버전 정보", "개발자 정보"]
    let thirdSectionList = ["로그아웃"]
    let url = ["https://cheddar-liquid-051.notion.site/1a22db662cb5416caaf6d08b58e98b1a", "https://cheddar-liquid-051.notion.site/1fcdb884cf8a45a58359e23d64bce4fd", "https://cheddar-liquid-051.notion.site/14fc6c632471488486e7e76bc161069e",
               "https://cheddar-liquid-051.notion.site/9b109514a74349f4988c9b7f72fe4e47"]
    
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

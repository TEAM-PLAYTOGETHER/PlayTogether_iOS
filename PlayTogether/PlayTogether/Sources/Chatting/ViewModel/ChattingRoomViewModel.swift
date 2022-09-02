//
//  ChattingRoomViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

import UIKit
import RxSwift
import Moya
import RxMoya

final class ChattingRoomViewModel {
    private let disposeBag = DisposeBag()
    var existingMessageSubject = BehaviorSubject<[Message?]>(value: [])
    
    init (roomID: Int) {
        fetchExistingMessageList(roomID: roomID)
    }
    
    func fetchExistingMessageList(roomID: Int) {
        let provider = MoyaProvider<ChattingService>()
        provider.rx.request(.messageListRequest(roomID: roomID))
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(MessageListResponse.self)
                    guard let data = responseData?.data.messages else { return }
                    self?.existingMessageSubject.onNext(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

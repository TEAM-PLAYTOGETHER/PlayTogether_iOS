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
    let roomID: Int
    let receiverID: Int
    var messageCount = Int()
    
    init (roomID: Int, receiverID: Int) {
        self.roomID = roomID
        self.receiverID = receiverID
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
                    self?.messageCount = data.count
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

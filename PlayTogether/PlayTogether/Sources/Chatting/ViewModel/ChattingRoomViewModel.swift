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
    
    //TODO: 삭제 예정
    let mockData = [
        Message(messageID: 0, send: false, read: true, createdAt: "2022-04-27T06:41:33.432Z", content: "첫 번째 메세지"),
        Message(messageID: 0, send: false, read: true, createdAt: "2022-04-27T06:42:33.432Z", content: "두 번째 메세지"),
        Message(messageID: 0, send: false, read: false, createdAt: "2022-04-27T06:43:33.432Z", content: "안녕하세요")
    ]
    
    init () {
        //TODO: 서버 연동 후 변경 예정
        existingMessageSubject.onNext(mockData)
    }
    
//    func fetchExistingChattingList() {
//        let provider = MoyaProvider<ChattingService>()
//        provider.rx.request(.chattingListRequest)
//            .subscribe { [weak self] result in
//                switch result {
//                case let .success(response):
//                    let responseData = try? response.map(ChattingRoomListResponse.self)
//                    guard let data = responseData?.data.chattingRooms else { return }
//                    self?.chattingRoomListSubject.onNext(data)
//                case let .failure(error):
//                    print(error.localizedDescription)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
}

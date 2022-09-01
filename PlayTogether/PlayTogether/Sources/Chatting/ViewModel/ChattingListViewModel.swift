//
//  ChattingListViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

import UIKit
import RxSwift
import Moya
import RxMoya

final class ChattingListViewModel {
    private let disposeBag = DisposeBag()
    var chattingRoomListSubject = BehaviorSubject<[ChattingRoom?]>(value: [])
    
    //TODO: 삭제 예정
    let mockData = [
        ChattingRoom(
            roomID: 0, audience: "김플투", audienceID: 0, send: false, read: false,
            createdAt: "2022-04-27T06:43:33.432Z", content: "안녕하세요"),
        ChattingRoom(roomID: 0, audience: "김유저", audienceID: 0, send: true, read: true,
                             createdAt: "2022-04-27T06:43:33.432Z", content: "배고프다")
    ]
    
    init () {
        //TODO: 서버 연동 후 변경 예정
        chattingRoomListSubject.onNext(mockData)
    }
    
    func fetchChattingRoomList() {
        let provider = MoyaProvider<ChattingService>()
        provider.rx.request(.chattingListRequest)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let responseData = try? response.map(ChattingRoomListResponse.self)
                    guard let data = responseData?.data.chattingRooms else { return }
                    self?.chattingRoomListSubject.onNext(data)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

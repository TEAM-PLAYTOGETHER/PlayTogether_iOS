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
    
    init () {
        fetchChattingRoomList()
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

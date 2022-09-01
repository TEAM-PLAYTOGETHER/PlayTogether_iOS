//
//  ChattingService.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

import Foundation
import Moya

enum ChattingService {
    case chattingListRequest
    case messageListRequest(roomID: Int)
}

extension ChattingService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .chattingListRequest:
            return APIConstants.chattingList
        case let .messageListRequest(roomID):
            return APIConstants.chattingList + "/\(roomID)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        let token = APIConstants.token
        return [
            "Content-Type": "application/json",
            "Authorization": token
        ]
    }
}

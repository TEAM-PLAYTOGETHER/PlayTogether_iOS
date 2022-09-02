//
//  LikeThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/28.
//

import Foundation
import Moya

enum LikeThunService {
    case likeThunRequest(lightId: Int)
}

extension LikeThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .likeThunRequest(let lightId):
            return APIConstants.postLikeThun + "/\(lightId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .likeThunRequest:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .likeThunRequest:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let token = APIConstants.token
        return [
            "Content-Type": "application/json",
            "Authorization": token
        ]
    }
}

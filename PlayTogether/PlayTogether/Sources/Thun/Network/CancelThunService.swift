//
//  CancelSubmittedService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/21.
//

import Foundation
import Moya

enum CancelThunService {
    case cancelThunRequest(lightId: Int)
}

extension CancelThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .cancelThunRequest(let lightId):
            return APIConstants.postDetailThunCancel + "/\(lightId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cancelThunRequest:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .cancelThunRequest:
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

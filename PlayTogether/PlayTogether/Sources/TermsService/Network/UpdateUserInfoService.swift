//
//  UpdateUserInfoService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/27.
//

import Moya
import Foundation

enum UpdateUserInfoService {
    case updateUserInfoRequest(gender: String, birthYear: Int)
}

extension UpdateUserInfoService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .updateUserInfoRequest:
            return APIConstants.updateUserInfo
        }
    }
    
    var method: Moya.Method {
        return .put
    }
    
    var task: Task {
        switch self {
        case .updateUserInfoRequest(let gender, let birthYear):
            let param : [String : Any] = [
                "gender" : gender,
                "birth" : birthYear
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
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



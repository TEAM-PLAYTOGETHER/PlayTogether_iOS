//
//  DeleteThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/28.
//

import Foundation
import Moya

enum DeleteThunService {
    case deleteThunRequest(lightId: Int)
}

extension DeleteThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .deleteThunRequest(lightId: let lightId):
            return APIConstants.postDeleteThun + "/\(lightId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteThunRequest:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .deleteThunRequest:
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


//
//  ThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/28.
//

import Foundation
import Moya

enum ThunService {
    case submittedRequest
    case openedRequest
    case likedRequest
}

extension ThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    var path: String {
        switch self {
        case .submittedRequest:
            return APIConstants.getSubmittedThunList + "/\(APIConstants.crewID)" + "/enter"
        case .openedRequest:
            return APIConstants.getOpenedThunList + "/\(APIConstants.crewID)" + "/open"
        case .likedRequest:
            return APIConstants.getLikedThunList + "/\(APIConstants.crewID)" + "/scrap"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        let token = APIConstants.token
        return [
            "Content-Type": "application/json",
            "Authorization": token
        ]
    }
}

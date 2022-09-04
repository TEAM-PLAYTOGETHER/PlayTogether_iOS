//
//  HomeService.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

import Moya
import Foundation

enum HomeService {
    case crewListRequest
    case hotThunRequest
    case newThunRequest
}

extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .crewListRequest:
            return APIConstants.getCrewList
        case .hotThunRequest:
            return APIConstants.getHotThunList
        case .newThunRequest:
            return APIConstants.getNewThunList
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

//
//  HomeService.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

import Moya
import Foundation

enum HomeService {
    case hotThunRequest
    case newThunRequest
}

extension HomeService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .hotThunRequest:
            return APIConstants.getHotThunList
        case .newThunRequest:
            return APIConstants.getNewThunList
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .hotThunRequest:
            return .get
        case .newThunRequest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .hotThunRequest:
            return .requestPlain
        case .newThunRequest:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let token = APIConstants.token
        return [
            "Content-Type": "multipart/form-data",
            "Authorization": token
        ]
    }
}

//
//  ThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/28.
//

import Foundation
import Moya

enum ThunService {
    case submittedRequest(pageSize: Int, curpage: Int)
    case openedRequest(pageSize: Int, curpage: Int)
    case likedRequest(pageSize: Int, curpage: Int)
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
        switch self {
        case .submittedRequest(let pageSize, let curpage):
            let params = [
                "pageSize": pageSize,
                "curpage": curpage
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .openedRequest(let pageSize, let curpage):
            let params = [
                "pageSize": pageSize,
                "curpage": curpage
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .likedRequest(let pageSize, let curpage):
            let params = [
                "pageSize": pageSize,
                "curpage": curpage
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let token = APIConstants.token
        return [
            "Content-Type": "application/json",
            "Authorization": token
        ]
    }
}

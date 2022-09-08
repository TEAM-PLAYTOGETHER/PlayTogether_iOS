//
//  FetchMeetingService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/02.
//

import Moya
import Foundation

enum FetchMeetingService {
    case fetchMeetingRequest(Void)
}

extension FetchMeetingService: TargetType {
    var baseURL: URL {
        switch self {
        case .fetchMeetingRequest:
            return URL(string: APIConstants.baseUrl)!
        }
    }
        
    var path: String {
        switch self {
        case .fetchMeetingRequest:
            return APIConstants.getStationList
        }
    }
            
    var method: Moya.Method {
        return .get
    }
            
    var task: Task {
        return .requestPlain
    }
                
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
            ]
    }
}


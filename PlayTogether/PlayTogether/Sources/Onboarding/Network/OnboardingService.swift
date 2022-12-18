//
//  OnboardingService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/12/18.
//

import Moya
import Foundation

enum OnboardingService {
    case getCrewInfo(jwtToken: String)
}

extension OnboardingService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        return APIConstants.getCrewList
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCrewInfo(let jwtToken):
            return [
                "Content-Type": "application/json",
                "Authorization": jwtToken
            ]
            
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}

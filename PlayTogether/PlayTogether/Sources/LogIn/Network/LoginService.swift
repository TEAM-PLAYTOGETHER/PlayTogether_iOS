//
//  LoginService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/23.
//

import Moya
import Foundation

enum LoginService {
    case kakaoLoginReuest(accessToken: String, fcmToken: String)
    case appleLoginReuset
}

extension LoginService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .kakaoLoginReuest:
            return APIConstants.kakaoLogin
            
        case .appleLoginReuset:
            return APIConstants.appleLogin
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        switch self {
        case .kakaoLoginReuest(let accessToken, let fcmToken):
            return [
                "Content-Type": "application/json",
                "accessToken" : accessToken,
                "fcmToken": fcmToken
            ]
            
        case .appleLoginReuset:
            return [
                "Content-Type": "application/json",
                "accessToken" : "",
                "fcmToken": ""
            ]
        }
    }
}


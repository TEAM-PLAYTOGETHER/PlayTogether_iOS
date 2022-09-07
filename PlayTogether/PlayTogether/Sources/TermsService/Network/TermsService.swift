//
//  TermsService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/06.
//

import Moya
import Foundation

enum TermService {
    case registerUserInfo(gerner: String, birthYear: Int)
}

extension TermService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        return APIConstants.registerUserInfo
    }
    
    var method: Moya.Method {
        return .put
    }
    
    var task: Task {
        switch self {
        case .registerUserInfo(let gender, let birthYear):
            let bodyData: [String : Any] = [
                "gerner" : gender,
                "birth" : birthYear
            ]
            return .requestParameters(parameters: bodyData, encoding: URLEncoding.queryString)
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

//
//  ReportThunService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/27.
//

import Foundation
import Moya

enum ReportThunService {
    case reportThunRequest(lightId: Int, report: String)
}

extension ReportThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .reportThunRequest(let lightId, _):
            return APIConstants.postReportThun + "/\(lightId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reportThunRequest:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .reportThunRequest(_, let report):
               return .requestParameters(parameters: ["report": report], encoding: JSONEncoding.default)
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



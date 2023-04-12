//
//  DetailThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/15.
//

import Foundation
import Moya

enum DetailThunService {
    case detailThunRequest(lightId: Int)
}

extension DetailThunService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .detailThunRequest(let lightId):
            return APIConstants.getDetailThunList + "/\(lightId)/detail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .detailThunRequest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .detailThunRequest:
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

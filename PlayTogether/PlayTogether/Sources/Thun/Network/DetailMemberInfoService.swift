//
//  ReportThunService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/27.
//

import Foundation
import Moya

enum DetailMemberInfoService {
    case detailMemberInfoRequest(memberId: Int)
}

extension DetailMemberInfoService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .detailMemberInfoRequest(let memberId):
            return APIConstants.getDetailMemberInfo + "/\(memberId)/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .detailMemberInfoRequest:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .detailMemberInfoRequest:
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




//
//  ThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/28.


import Foundation
import Moya

enum ThunListService {
    case eatGoDoRequest(pageSize: Int, curpage: Int, category: String, sort: String)
}

extension ThunListService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    var path: String {
        switch self {
        case .eatGoDoRequest:
            return APIConstants.getEatGoDoThunList
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .eatGoDoRequest(let pageSize, let curpage, let category, let sort):
            let params = [
                "pageSize": pageSize,
                "curpage": curpage,
                "category": category,
                "sort": sort
            ] as [String : Any]
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


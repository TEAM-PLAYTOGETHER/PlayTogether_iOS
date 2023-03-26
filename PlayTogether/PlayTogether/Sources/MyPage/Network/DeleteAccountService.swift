//
//  DetailThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/15.
//

import Foundation
import Moya

enum DeleteAccountService {
    case deleteAccount
    case deleteCrew
}

extension DeleteAccountService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .deleteAccount:
            return APIConstants.deleteAccount
        case .deleteCrew:
            return APIConstants.deleteCrew
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteAccount:
            return .delete
        case .deleteCrew:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .deleteAccount:
            return .requestPlain
        case .deleteCrew:
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


//
//  ThunService.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/28.
//

//import Foundation
//import Moya
//
//enum ThunListService {
//    case eatRequest
//}
//
//extension ThunListService: TargetType {
//    var baseURL: URL {
//        return URL(string: APIConstants.baseUrl)!
//    }
//    var path: String {
//        switch self {
//        case .submittedRequest:
//            return APIConstants.getSubmittedThunList + "/\(APIConstants.crewID)" + "/enter"
//        }
//    }
//
//    var method: Moya.Method {
//        return .get
//    }
//
//    var task: Task {
//        return .requestPlain
//    }
//
//    var headers: [String : String]? {
//        let token = APIConstants.token
//        return [
//            "Content-Type": "application/json",
//            "Authorization": token
//        ]
//    }
//}


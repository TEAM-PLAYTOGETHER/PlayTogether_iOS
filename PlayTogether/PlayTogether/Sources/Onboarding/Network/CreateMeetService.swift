//
//  CreateMeetService.swift
//  PlayTogether
//
//  Created by 이지석 on 2023/02/09.
//

import Moya
import Foundation

enum CreateMeetService {
    case createMeetRequest(crewName: String, description: String, jwt: String)
}

extension CreateMeetService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseUrl)!
    }
    
    var path: String {
        return APIConstants.postCreateMeet
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .createMeetRequest(let crewName, let description, _):
            let param: [String : Any] = [
                "crewName": crewName,
                "description": description
            ]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case .createMeetRequest(_, _, let jwt):
            return [
                "Content-Type": "application/json",
                "Authorization": jwt
            ]
        }
    }
}

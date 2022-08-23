//
//  SubwayStationService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

import Moya
import Foundation

enum SelfIntroduceService {
    case searchStationRequeset(stationName: String)
    case existingNicknameRequset(crewID: Int, Nickname: String)
}

extension SelfIntroduceService: TargetType {
    var baseURL: URL {
        switch self {
        case .searchStationRequeset:
            return URL(string: APIConstants.subwayBaseUrl)!
            
        case .existingNicknameRequset:
            return URL(string: APIConstants.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .searchStationRequeset:
            return APIConstants.getStationList
            
        case .existingNicknameRequset(let crewID, _):
            return APIConstants.existingNickname + "/\(crewID)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .searchStationRequeset(let stationName):
            let params = [
                "serviceKey" : APIConstants.subwayServiceKey,
                "_type" : "json",
                "subwayStationName" : stationName
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .existingNicknameRequset(_, let nickname):
            let param = [
                "nickname" : nickname
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }   
}

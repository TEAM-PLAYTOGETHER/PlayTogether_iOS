//
//  SubwayStationService.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

import Moya
import Foundation

enum SelfIntroduceService {
    case searchStationRequeset
    case existingNicknameRequset(crewID: Int, Nickname: String)
    case registerUserSubwayStations(
        crewID: Int,
        nickName: String,
        description: String,
        firstSubway: String,
        secondSubway: String? = nil
    )
}

extension SelfIntroduceService: TargetType {
    var baseURL: URL {
        switch self {
        case .searchStationRequeset:
            return URL(string: APIConstants.subwayBaseUrl)!
            
        case .existingNicknameRequset,
             .registerUserSubwayStations:
            return URL(string: APIConstants.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .searchStationRequeset:
            return APIConstants.getStationList
            
        case .existingNicknameRequset(let crewID, _):
            return APIConstants.existingNickname + "/\(crewID)/nickname"
            
        case .registerUserSubwayStations(let crewID, _, _, _, _):
            return APIConstants.putRegisterUserSubway + "\(crewID)"
            
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .searchStationRequeset:
            return .requestPlain
            
        case .existingNicknameRequset(_, let nickname):
            let param = [
                "nickname" : nickname
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .registerUserSubwayStations(_, let nickName, let description, let firstSubway, let secondSubway):
            let param: [String : Any] = [
                "nickname" : nickName,
                "description" : description,
                "firstSubway" : firstSubway,
                "secondSubway" : secondSubway as Any
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

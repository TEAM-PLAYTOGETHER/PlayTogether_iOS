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
    case existingNicknameRequset(crewID: Int, nickName: String)
    case registerUserSubwayStations(
        crewID: Int,
        nickName: String,
        description: String,
        firstSubway: String?,
        secondSubway: String?
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
            return APIConstants.putRegisterUserSubway + "/\(crewID)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchStationRequeset,
             .existingNicknameRequset:
            return .get
            
        case .registerUserSubwayStations:
            return .put
        }
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
            var param: [String:Any] = [
                "nickname" : nickName,
                "description" : description
            ]
            
            guard let firstSubway = firstSubway else {
                return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            }
            param = [
                "nickname" : nickName,
                "description" : description,
                "firstSubway" : firstSubway
            ]

            guard let secondSubway = secondSubway else {
                return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            }
            param = [
                "nickname" : nickName,
                "description" : description,
                "firstSubway" : firstSubway,
                "secondSubway" : secondSubway
            ]
            
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchStationRequeset,
                .existingNicknameRequset:
            return [
                "Content-Type": "application/json"
            ]
            
        case .registerUserSubwayStations:
            let jwt = UserDefaults.standard.string(forKey: "accessToken") ?? ""
            return [
                "Content-Type": "application/json",
                "Authorization" : jwt
            ]
        }
    }   
}

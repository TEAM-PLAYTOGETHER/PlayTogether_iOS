//
//  APIConstants.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

struct APIConstants {
    //TODO: 추후 key로 숨길 예정
    static let baseUrl = "http://13.125.232.150:3000/api"
    static let socketUrl = "ws://13.125.232.150:3000"
    static let subwayBaseUrl = "http://openapi.seoul.go.kr:8088"
    
    //TODO: 추후 삭제 예정
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE2OCIsImVtYWlsIjoic2V1bmdoZW9uMzI4QGdtYWlsLmNvbSIsImlhdCI6MTY2NDQ0MDAzNSwiZXhwIjoxNjk1OTk3NjM1LCJpc3MiOiJwbGF5dG9nZXRoZXIifQ.ljT7GMJhM1iKx7G34vVdD_s6AWax0nQHao1Rvne3t6Q"
    static var crewID = 2
    static var crewName = "아요크루"
    static let subwayServiceKey = "Gd9kQKfYBRl%2Bfk8CBPW9CHL5ZFvQUWQiIR6yQ%2F84qRh8HclgviJO9lCOI%2BRHmz%2BPZ9FMdjJWgzn31z8MmVNN2g%3D%3D"
    
    // home
    static let getCrewList = "/crew/list"
    
    // light
    static var getHotThunList = {
        return "/light/\(crewID)/hot"
    }
    
    static var getNewThunList = {
        return "/light/\(crewID)/new"
    }
    
    static let createThun = "/light/add"
    static let getSubmittedThunList = "/light"
    static let getOpenedThunList = "/light"
    static let getLikedThunList = "/light"
    static let getDetailThunList = "/light/detail"
    static let postDetailThunCancel = "/light/enter"
    static let postLikeThun = "/scrap"
    static let getExistLikeThun = "/scrap/exist"
    static let postDeleteThun = "light/remove"
    static let getExistThun = "light/exist"
    static let getEatGoDoThunList = "light/\(crewID)"
    static let getSearchThun = "light/\(crewID)/search"
    static let postReportThun = "light/report"
    
    // login
    static let kakaoLogin = "/auth/kakao-login"
    static let appleLogin = "/auth/apple-login"
    
    // subway
    static let getStationList = "/46424177746a697338326b714a6755/json/SearchSTNBySubwayLineInfo/1/1000"
    
    // message
    static let chattingList = "/message"
    
    // user
    static let updateUserInfo = "/user/signup"
    static let existingNickname = "/user/crew"
    static let getDetailMemberInfo = "/user/\(crewID)"
}

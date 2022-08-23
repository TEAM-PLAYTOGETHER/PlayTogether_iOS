//
//  APIConstants.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

struct APIConstants {
    //TODO: 추후 key로 숨길 예정
    static let baseUrl = "http://13.125.232.150:3000/api"
    static let subwayBaseUrl = "http://apis.data.go.kr/1613000/SubwayInfoService"
    
    //TODO: 추후 삭제 예정
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjgxIiwidXNlckxvZ2luSWQiOiJpb3NUZXN0IiwiaWF0IjoxNjU4ODU2OTEwLCJleHAiOjE2NjE0NDg5MTAsImlzcyI6InBsYXl0b2dldGhlciJ9.dtWSxC8zZNQlnffughIdjMiA6wFNO3zUJ476pfoUtvA"
    static let crewID = 102
    
    static let subwayServiceKey = "Gd9kQKfYBRl%2Bfk8CBPW9CHL5ZFvQUWQiIR6yQ%2F84qRh8HclgviJO9lCOI%2BRHmz%2BPZ9FMdjJWgzn31z8MmVNN2g%3D%3D"
    
    // light
    static let getHotThunList = "/light/hot"
    static let getNewThunList = "/light/new"
    static let existingNickname = "/user/crew"
    
    // subway
    static let getStationList = "/getKwrdFndSubwaySttnList"
    static let getSubmittedThunList = "/light"
    static let getOpenedThunList = "/light"
    static let getLikedThunList = "/light"
    static let getDetailThunList = "/light/detail"
    
    static let postDetailThunCancel = "/light/enter"
}

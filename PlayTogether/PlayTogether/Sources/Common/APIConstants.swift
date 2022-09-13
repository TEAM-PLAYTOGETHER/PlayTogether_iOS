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
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE0OSIsImVtYWlsIjoibHNoMzI4MzI4QG5hdmVyLmNvbSIsImlhdCI6MTY2MTk5OTY4NSwiZXhwIjoxNjYzMjA5Mjg1LCJpc3MiOiJwbGF5dG9nZXRoZXIifQ._9JSak-HTLTdDYD6NAFe0TwwqHrkOFCTmBtnTsC8uns"
    static let crewID = 2
    
    static let subwayServiceKey = "Gd9kQKfYBRl%2Bfk8CBPW9CHL5ZFvQUWQiIR6yQ%2F84qRh8HclgviJO9lCOI%2BRHmz%2BPZ9FMdjJWgzn31z8MmVNN2g%3D%3D"
    
    // light
    static let getHotThunList = "/light/\(crewID)/hot"
    static let getNewThunList = "/light/\(crewID)/new"
    static let createThun = "/light/add"
    static let getSubmittedThunList = "/light"
    static let getOpenedThunList = "/light"
    static let getLikedThunList = "/light"
    static let getDetailThunList = "/light/detail"
    static let postDetailThunCancel = "/light/enter"
    static let existingNickname = "/user/crew"
    static let postLikeThun = "/scrap"
    static let getExistLikeThun = "/scrap/exist"
    static let postDeleteThun = "light/remove"
    static let getExistThun = "light/exist"
    static let getSearchThun = "light/\(crewID)/search"
    
    // subway
    static let getStationList = "/getKwrdFndSubwaySttnList"
}

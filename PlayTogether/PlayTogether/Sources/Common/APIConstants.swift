//
//  APIConstants.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

struct APIConstants {
    //TODO: 추후 key로 숨길 예정
    static let baseUrl = "http://13.125.232.150:3000/api"
    static let subwayBaseUrl = "http://openapi.seoul.go.kr:8088"
    
    //TODO: 추후 삭제 예정
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE2OCIsImVtYWlsIjoic2V1bmdoZW9uMzI4QGdtYWlsLmNvbSIsImlhdCI6MTY2MzI0NzQ3NCwiZXhwIjoxNjY0NDU3MDc0LCJpc3MiOiJwbGF5dG9nZXRoZXIifQ.-xmo_D6ojG6BQlu8phsPsSuG71M_A5Ph42PjGEpgUHk"
    static let crewID = 2
    
    // light
    static let getHotThunList = "/light/\(crewID)/hot"
    static let getNewThunList = "/light/\(crewID)/new"
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
    
    // subway
    static let getStationList = "/46424177746a697338326b714a6755/json/SearchSTNBySubwayLineInfo/1/1000"
    
    // user
    static let updateUserInfo = "/user/signup"
    static let existingNickname = "/user/crew"
}

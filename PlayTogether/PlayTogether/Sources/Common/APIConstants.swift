//
//  APIConstants.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

struct APIConstants {
    static let baseUrl = "http://13.125.232.150:3000/api"
    
    // 추후 삭제 예정
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjgxIiwidXNlckxvZ2luSWQiOiJpb3NUZXN0IiwiaWF0IjoxNjU4ODU2OTEwLCJleHAiOjE2NjE0NDg5MTAsImlzcyI6InBsYXl0b2dldGhlciJ9.dtWSxC8zZNQlnffughIdjMiA6wFNO3zUJ476pfoUtvA"
    
    // light
    static let getHotThunList = "/light/hot"
    static let getNewThunList = "/light/new"
}

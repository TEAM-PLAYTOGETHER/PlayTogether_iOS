//
//  LoginResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/23.
//

struct LoginResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: LoginUserInfo
}

struct LoginUserInfo: Codable {
    let userName, accessToken, refreshToken: String
    let isSignup: Bool
}

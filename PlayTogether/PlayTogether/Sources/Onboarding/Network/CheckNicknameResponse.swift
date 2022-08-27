//
//  existingNicknameResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/15.
//

struct CheckNicknameResponse: Decodable {
    let status: String
    let success: Bool
    let message: String
}

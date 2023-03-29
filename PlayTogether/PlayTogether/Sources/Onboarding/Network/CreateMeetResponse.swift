//
//  CreateMeetResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2023/02/09.
//

struct CreateMeetResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: CreateMeetData?
}

struct CreateMeetData: Codable {
    let id: Int
    let name, code, description: String
}

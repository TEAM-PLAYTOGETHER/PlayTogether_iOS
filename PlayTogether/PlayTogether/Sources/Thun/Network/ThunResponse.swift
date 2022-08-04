//
//  ThunResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/28.
//

import Foundation

struct ThunResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: ThunResponseData
}

struct ThunResponseData: Decodable {
    let lightData: [ThunResponseList]
    let totalCount, totalPage: Int
}

struct ThunResponseList: Decodable {
    let lightID: Int
    let title, category: String
    let scpCnt: Int
    let date, time: String
    let peopleCnt: Int
    let place: String
    let lightMemberCnt: Int

    enum CodingKeys: String, CodingKey {
        case lightID = "light_id"
        case title, category
        case scpCnt = "scp_cnt"
        case date, time
        case peopleCnt = "people_cnt"
        case place
        case lightMemberCnt = "LightMemberCnt"
    }
}

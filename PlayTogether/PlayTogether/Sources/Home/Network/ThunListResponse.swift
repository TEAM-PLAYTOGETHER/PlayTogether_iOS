//
//  ThunListResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/02.
//

struct ThunListResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: ThunList
}

struct ThunList: Decodable {
    let lightData: [LightList]
    let offset, limit, totalCount, totalPage: Int
}

struct LightList: Decodable {
    let lightID: Int
    let title, category: String
    let scpCnt: Int
    let date, time: String?
    let peopleCnt: Int?
    let place: String?
    let lightMemberCnt: Int
    let isOpened: Bool

    enum CodingKeys: String, CodingKey {
        case lightID = "light_id"
        case title, category
        case scpCnt = "scp_cnt"
        case date, time
        case peopleCnt = "people_cnt"
        case place
        case lightMemberCnt = "LightMemberCnt"
        case isOpened = "is_opened"
    }
}

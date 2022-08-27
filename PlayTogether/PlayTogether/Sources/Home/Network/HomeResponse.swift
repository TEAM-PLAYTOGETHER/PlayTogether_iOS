//
//  HomeResponse.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/27.
//

struct HomeResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: [HomeResponseList]
}

struct HomeResponseList: Decodable {
    let lightID: Int
    let category: String
    let likedCount: Int
    let nowMemberCount: Int
    let title, date, time: String
    let totalMemberCount: Int
    let place: String

    enum CodingKeys: String, CodingKey {
        case lightID = "light_id"
        case category
        case likedCount = "scp_cnt"
        case nowMemberCount = "LightMemberCnt"
        case title, date, time
        case totalMemberCount = "people_cnt"
        case place
    }
}

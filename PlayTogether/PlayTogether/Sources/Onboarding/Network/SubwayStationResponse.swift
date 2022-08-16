//
//  SubwayStationResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

struct StationResponse: Codable {
    let response: ResponseData
}

struct ResponseData: Codable {
    let header: Header
    let body: Body
}

struct Body: Codable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

struct Items: Codable {
    let item: [StationsInfo]
}

struct StationsInfo: Codable {
    let subwayRouteName, subwayStationID, subwayStationName: String

    enum CodingKeys: String, CodingKey {
        case subwayRouteName
        case subwayStationID = "subwayStationId"
        case subwayStationName
    }
}

struct Header: Codable {
    let resultCode, resultMsg: String
}

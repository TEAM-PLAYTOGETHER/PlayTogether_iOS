//
//  SubwayStationResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

struct StationResponse: Decodable {
    let response: ResponseData
}

struct ResponseData: Decodable {
    let header: Header
    let body: Body
}

struct Body: Decodable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

struct Items: Decodable {
    let item: [StationsInfo]
}

struct StationsInfo: Decodable {
    let subwayRouteName, subwayStationID, subwayStationName: String

    enum CodingKeys: String, CodingKey {
        case subwayRouteName
        case subwayStationID = "subwayStationId"
        case subwayStationName
    }
}

struct Header: Decodable {
    let resultCode, resultMsg: String
}

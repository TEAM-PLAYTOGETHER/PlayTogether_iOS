//
//  SubwayStationResponse.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/13.
//

struct SubwayStationResponse: Codable {
    let searchSTNBySubwayLineInfo: SubwayLineInfo

    enum CodingKeys: String, CodingKey {
        case searchSTNBySubwayLineInfo = "SearchSTNBySubwayLineInfo"
    }
}

struct SubwayLineInfo: Codable {
    let listTotalCount: Int
    let result: Result
    let row: [SubwayList]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

struct Result: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct SubwayList: Codable {
    let stationCD, stationName, stationNameEng, lineNum: String
    let frCode: String

    enum CodingKeys: String, CodingKey {
        case stationCD = "STATION_CD"
        case stationName = "STATION_NM"
        case stationNameEng = "STATION_NM_ENG"
        case lineNum = "LINE_NUM"
        case frCode = "FR_CODE"
    }
}

//
//  ChattingListResponse.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

struct ChattingRoomListResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: ChattingRoomList
}

struct ChattingRoomList: Decodable {
    let chattingRooms: [ChattingRoom]
    
    enum CodingKeys: String, CodingKey {
        case chattingRooms = "messages"
    }
}

struct ChattingRoom: Decodable {
    let roomID: Int
    let audience: String
    let audienceID: Int
    let send, read: Bool
    var createdAt, content: String

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case audience
        case audienceID = "audienceId"
        case send, read, createdAt, content
    }
}

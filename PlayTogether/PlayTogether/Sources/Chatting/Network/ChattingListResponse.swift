//
//  ChattingListResponse.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

struct ChattingListResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: ChattingRoomListResponse
}

struct ChattingRoomListResponse: Decodable {
    let chattingRooms: [ChattingRoomResponse]
    
    enum CodingKeys: String, CodingKey {
        case chattingRooms = "messages"
    }
}

struct ChattingRoomResponse: Decodable {
    let roomID: Int
    let audience: String
    let audienceID: Int
    let send, read: Bool
    let createdAt, content: String

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case audience
        case audienceID = "audienceId"
        case send, read, createdAt, content
    }
}

//
//  ExistingChattingResponse.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/01.
//

struct MessageListResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
    let data: MessageList
}

// MARK: - DataClass
struct MessageList: Decodable {
    let messages: [Message]
}

// MARK: - Message
struct Message: Decodable {
    let messageID: Int
    let send, read: Bool
    let createdAt, content: String

    enum CodingKeys: String, CodingKey {
        case messageID = "messageId"
        case send, read, createdAt, content
    }
}

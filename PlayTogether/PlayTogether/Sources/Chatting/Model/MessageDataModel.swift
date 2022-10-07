//
//  MessageDataModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/02.
//

struct MessageDataModel: Encodable {
    let receiverID: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case receiverID = "recvId"
        case message = "content"
    }
}

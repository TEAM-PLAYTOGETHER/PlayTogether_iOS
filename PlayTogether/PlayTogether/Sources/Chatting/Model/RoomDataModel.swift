//
//  RoomDataModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/02.
//

struct RoomDataModel: Encodable {
    let receiverID: Int
    let roomID: Int
    
    enum CodingKeys: String, CodingKey {
        case receiverID = "recvId"
        case roomID = "roomId"
    }
}

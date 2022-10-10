//
//  SoketIOManger.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/31.
//

import UIKit
import SocketIO

final class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    private let manager = SocketManager(
        socketURL: URL(string: APIConstants.socketUrl)!,
        config: [.log(true), .compress, .extraHeaders(["Authorization": APIConstants.token])]
    )
    
    var socket: SocketIOClient {
        return manager.defaultSocket
    }
    
    private var receiverID = Int()
    private var roomID = Int()
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        closeConnection()
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func reqEnterRoom(receiverID: Int, roomID: Int) {
        self.receiverID = receiverID
        self.roomID = roomID
        
        let room = RoomDataModel(receiverID: receiverID, roomID: roomID)
        socket.emit("reqEnterRoom", jsonDataMaker(room))
    }
    
    func reqSendMessage(_ text: String) {
        let message = MessageDataModel(receiverID: receiverID, message: text)
        socket.emit("reqSendMessage", jsonDataMaker(message))
    }
    
    func reqExitRoom() {
        socket.emit("reqExitRoom")
    }
}

extension SocketIOClient {
    func subscribeOn(_ event: String, callback: @escaping ([String: Any]) -> Void) {
        on(event) { (data, _) in
            guard let dataString = data[0] as? String,
                  let data = dataString.data(using: .utf8),
                  let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            else { return }

            callback(response)
        }
    }
}

private extension SocketIOManager {
    func jsonDataMaker<T: Encodable>(_ dataModel: T) -> Data {
        guard let jsonData = try? JSONEncoder().encode(dataModel) else { return Data() }
        return jsonData
    }
}

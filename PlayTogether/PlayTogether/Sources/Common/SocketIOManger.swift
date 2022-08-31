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
        config: [.log(true), .compress]
    )
    
    private var socket: SocketIOClient {
        return manager.defaultSocket
    }
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

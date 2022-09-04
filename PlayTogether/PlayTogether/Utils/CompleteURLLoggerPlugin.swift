//
//  CompleteURLLoggerPlugin.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/04.
//

import Moya

final class CompleteUrlLoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let requestURL = request.request?.url?.absoluteString else { fatalError() }
        print(requestURL)
    }
}

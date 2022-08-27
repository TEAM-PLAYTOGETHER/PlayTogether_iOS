//
//  CancelSubmittedResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/21.
//

import Foundation

struct CancelSubmittedResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
}

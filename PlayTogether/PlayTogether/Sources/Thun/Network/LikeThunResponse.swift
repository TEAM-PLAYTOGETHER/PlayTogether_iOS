//
//  LikeThunResponse.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/28.
//

import Foundation

struct LikeThunResponse: Decodable {
    let status: Int
    let success: Bool
    let message: String
}

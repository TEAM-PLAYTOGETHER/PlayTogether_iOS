//
//  ThunDataModel.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/07/21.
//

import Foundation

class ThunDataModel {
    static let shared = ThunDataModel()
    
    var title: String?
    var date: String?
    var location: String?
    var time: Double?
    var personnel: String?
    var tag: String?
    var like: Int?
    
    private init() {}
}



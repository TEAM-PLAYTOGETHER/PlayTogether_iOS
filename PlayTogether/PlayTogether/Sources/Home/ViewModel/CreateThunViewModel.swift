//
//  CreateThunViewModel.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/29.
//

import UIKit
import RxRelay

final class CreateThunViewModel {
    var introduceImageRelay = BehaviorRelay<[UIImage]>.init(value: .init())
}

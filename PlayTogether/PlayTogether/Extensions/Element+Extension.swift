//
//  Element+Extension.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/15.
//

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

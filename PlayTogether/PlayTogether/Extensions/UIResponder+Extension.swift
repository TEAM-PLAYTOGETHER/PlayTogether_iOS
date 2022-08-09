//
//  UIResponder+Extension.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/09.
//

import UIKit

extension UIResponder {
    private struct StaticResponder {
        static weak var responder: UIResponder?
    }
    
    static func getCurrentResponder() -> UIResponder? {
        StaticResponder.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.registerResponder), to: nil, from: nil, for: nil)
        return StaticResponder.responder
    }
    
    @objc
    private func registerResponder() {
        StaticResponder.responder = self
    }
}

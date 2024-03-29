//
//  UIImageView + Extension.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/21.
//

import Foundation
import UIKit

extension UIImageView {
    /// url로 이미지 로드
    func loadImage(url: String) {
        DispatchQueue.global().async { [weak self] in
            guard let urlString = URL(string: url),
                  let data = try? Data(contentsOf: urlString),
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    /// url로 프로필 이미지 로드
    func loadProfileImage(url: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let urlString = URL(string: url),
                  let data = try? Data(contentsOf: urlString),
                  let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self.layer.cornerRadius = self.frame.height/2
                self.clipsToBounds = true
                self.image = image
            }
        }
    }
}

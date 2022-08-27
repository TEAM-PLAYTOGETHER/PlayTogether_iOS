//
//  DetailThunCollectionViewCell.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/12.
//

import UIKit

class SubmittedDetailThunCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView().then {
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension SubmittedDetailThunCollectionViewCell {
    func setupViews() {
        addSubview(imageView)
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

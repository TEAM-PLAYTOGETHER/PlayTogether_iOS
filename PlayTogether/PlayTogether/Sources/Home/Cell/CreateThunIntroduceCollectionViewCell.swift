//
//  CreateThunIntroduceCollectionViewCell.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/08/09.
//

import UIKit

final class CreateThunIntroduceCollectionViewCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    lazy var deleteImageButton = UIButton().then {
        $0.setImage(.ptImage(.deleteIcon), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension CreateThunIntroduceCollectionViewCell {
    func setupView() {
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(deleteImageButton)
        setupLayout()
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteImageButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
        }
    }
}

extension CreateThunIntroduceCollectionViewCell {
    func setupDate(image: UIImage, indexKey: Int) {
        imageView.image = image
        deleteImageButton.layer.setValue(indexKey, forKey: "index")
    }
}

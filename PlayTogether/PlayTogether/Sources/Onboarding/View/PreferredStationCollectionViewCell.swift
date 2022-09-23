//
//  PreferredStationTableViewCell.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/22.
//

import UIKit
import RxSwift

protocol PreferredStationDelegate: AnyObject {
    func removeStation()
}

final class PreferredStationCollectionViewCell: UICollectionViewCell {
    private lazy var disposeBag = DisposeBag()
    
    weak var delegate: PreferredStationDelegate?
    
    private lazy var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptGreen
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.setImage(.ptImage(.exitIcon), for: .normal)
        $0.tintColor = .ptGray01
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PreferredStationCollectionViewCell {
    func setupView() {
        backgroundColor = .ptBlack01
        layer.cornerRadius = self.frame.height / 2
        
        addSubview(titleLabel)
        addSubview(cancelButton)
        
        setupLayout()
        setupBinding()
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview().inset(8)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview().inset(8)
        }
    }
    
    func setupBinding() {
        cancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.delegate?.removeStation()
            })
            .disposed(by: disposeBag)
    }
}

extension PreferredStationCollectionViewCell {
    func setupData(_ title: String) {
        titleLabel.text = title
    }
}

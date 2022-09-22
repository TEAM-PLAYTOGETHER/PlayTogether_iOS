//
//  LoginButtonView.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/02.
//

import UIKit
import RxSwift

enum loginType {
    case kakaoLogin
    case appleLogin
}
// TODO: 액션 프로토콜 넣어주기
protocol LoginButtonDelegate: class {
    func kakaoButtonDidTap()
    func appleButtonDidTap()
}

class LoginButtonView: UIView {
    private lazy var disposeBag = DisposeBag()
    weak var delegate: LoginButtonDelegate?
    
    private let logoImageView = UIImageView()
    
    private let titleLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
    }
    
    private let tapGseture = UITapGestureRecognizer(
        target: LoginButtonView.self,
        action: nil
    ).then {
        $0.cancelsTouchesInView = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginButtonView {
    func setupView() {
        layer.cornerRadius = 5.0
        
        addSubview(logoImageView)
        addSubview(titleLabel)
    }
    
    func setupLayout(_ type: loginType) {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(type == .kakaoLogin ? 17 : 14)
            $0.top.bottom.equalToSuperview().inset(type == .kakaoLogin ? 10.5 : 6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func setupBinding(_ type: loginType) {
        self.addGestureRecognizer(tapGseture)
        
        tapGseture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                type == .kakaoLogin ?
                self?.delegate?.kakaoButtonDidTap() : self?.delegate?.appleButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
}


extension LoginButtonView {
    func setupUI(_ type: loginType) {
        switch type {
        case .kakaoLogin:
            logoImageView.image = .ptImage(.kakaoLoginIcon)
            titleLabel.text = "카카오 로그인"
            titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
            backgroundColor = .kakaoColor
            
        case .appleLogin:
            logoImageView.image = .ptImage(.appleLoginIcon)
            titleLabel.text = "Apple로 로그인"
            titleLabel.textColor = .white
            backgroundColor = .black
        }
        
        setupLayout(type)
        setupBinding(type)
    }
}

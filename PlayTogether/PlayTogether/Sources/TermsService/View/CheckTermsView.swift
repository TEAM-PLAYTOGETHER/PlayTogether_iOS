//
//  CheckTermsView.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/09/04.
//

import UIKit
import RxSwift

protocol checkTermsProtocol: class {
    func allCheckButtonDidTap(_ button: UIButton)
    func ageCheckButtonDidTap(_ button: UIButton)
    func termsCheckButtonDidTap(_ button: UIButton)
    func privacyCheckButtonDidTap(_ button: UIButton)
    func marketingCheckButtonDidTap(_ button: UIButton)
}

class CheckTermsView: UIView {
    private lazy var disposeBag = DisposeBag()
    weak var delegate: checkTermsProtocol?
    
    var allCheckButton = UIButton().then {
        $0.setupToggleButtonUI()
    }
    
    private let allCheckLabel = UILabel().then {
        $0.text = "전체 동의"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 16)
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    var ageCheckButton = UIButton().then {
        $0.setupToggleButtonUI()
    }
    
    private let ageCheckLabel = UILabel().then {
        $0.text = "(필수) 만 18세 이상"
        $0.textColor = .ptBlack02
        $0.font = .pretendardRegular(size: 16)
    }
    
    var termsCheckButton = UIButton().then {
        $0.setupToggleButtonUI()
    }
    
    private let termsCheckLabel = UILabel().then {
        $0.text = "(필수) 이용약관 동의"
        $0.textColor = .ptBlack02       // TODO: 색, 폰트 섞여있음, 밑줄 NSAtributed 넣어주기 + TapGesture
        $0.font = .pretendardRegular(size: 16)
    }
    
    var privacyCheckButton = UIButton().then {
        $0.setupToggleButtonUI()
    }
    
    private let privacyCheckLabel = UILabel().then {
        $0.text = "(필수) 개인정보 수집 및 이용 동의"
        $0.textColor = .ptBlack02
        $0.font = .pretendardRegular(size: 16)
    }
    
    var marketingCheckButton = UIButton().then {
        $0.setupToggleButtonUI()
    }
    
    private let marketingCheckLabel = UILabel().then {
        $0.text = "(선택) 마케팅 정보 수집 및 수신 동의"
        $0.textColor = .ptBlack02
        $0.font = .pretendardRegular(size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CheckTermsView {
    func setupView() {
        backgroundColor = .white
        layer.borderColor = UIColor.ptGray03.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        
        addSubview(allCheckButton)
        addSubview(allCheckLabel)
        addSubview(underLineView)
        addSubview(ageCheckButton)
        addSubview(ageCheckLabel)
        addSubview(termsCheckButton)
        addSubview(termsCheckLabel)
        addSubview(privacyCheckButton)
        addSubview(privacyCheckLabel)
        addSubview(marketingCheckButton)
        addSubview(marketingCheckLabel)
        
        setupLayout()
        setupBinding()
    }
    
    func setupLayout() {
        allCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(allCheckLabel)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        allCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(allCheckButton.snp.trailing).offset(11.04)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(allCheckLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        ageCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(ageCheckLabel)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        ageCheckLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(20)
            $0.leading.equalTo(ageCheckButton.snp.trailing).offset(11.04)
        }
        
        termsCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(termsCheckLabel)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        termsCheckLabel.snp.makeConstraints {
            $0.top.equalTo(ageCheckLabel.snp.bottom).offset(25)
            $0.leading.equalTo(termsCheckButton.snp.trailing).offset(11.04)
        }
        
        privacyCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(privacyCheckLabel)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        privacyCheckLabel.snp.makeConstraints {
            $0.top.equalTo(termsCheckLabel.snp.bottom).offset(25)
            $0.leading.equalTo(privacyCheckButton.snp.trailing).offset(11.04)
        }
        
        marketingCheckButton.snp.makeConstraints {
            $0.centerY.equalTo(marketingCheckLabel)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        marketingCheckLabel.snp.makeConstraints {
            $0.top.equalTo(privacyCheckLabel.snp.bottom).offset(25)
            $0.leading.equalTo(marketingCheckButton.snp.trailing).offset(11.04)
        }
        
    }
    
    func setupBinding() {
        allCheckButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                self.delegate?.allCheckButtonDidTap(self.allCheckButton)
            })
            .disposed(by: disposeBag)
        
        ageCheckButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                self.delegate?.ageCheckButtonDidTap(self.ageCheckButton)
            })
            .disposed(by: disposeBag)
        
        termsCheckButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                self.delegate?.termsCheckButtonDidTap(self.termsCheckButton)
            })
            .disposed(by: disposeBag)
        
        privacyCheckButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                self.delegate?.privacyCheckButtonDidTap(self.privacyCheckButton)
            })
            .disposed(by: disposeBag)
        
        marketingCheckButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let self = self else { return }
                self.delegate?.marketingCheckButtonDidTap(self.marketingCheckButton)
            })
            .disposed(by: disposeBag)
    }
}

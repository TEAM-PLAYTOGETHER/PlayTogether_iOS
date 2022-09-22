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
        $0.setTitle("   전체 동의", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 16)
        $0.setupToggleButtonUI()
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    var ageCheckButton = UIButton().then {
        $0.setTitle("   (필수) 만 18세 이상", for: .normal)
        $0.setTitleColor(.ptBlack02, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 16)
        $0.setupToggleButtonUI()
    }
    
    var termsCheckButton = UIButton().then {
        $0.setTitle("   (필수) 이용약관 동의", for: .normal)
        $0.setTitleColor(.ptBlack02, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 16)
        $0.setupToggleButtonUI()
    }
    
    var privacyCheckButton = UIButton().then {
        $0.setTitle("   (필수) 개인정보 수집 및 이용 동의", for: .normal)
        $0.setTitleColor(.ptBlack02, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 16)
        $0.setupToggleButtonUI()
    }
    
    var marketingCheckButton = UIButton().then {
        $0.setTitle("   (선택) 마케팅 정보 수집 및 수신 동의", for: .normal)
        $0.setTitleColor(.ptBlack02, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 16)
        $0.setupToggleButtonUI()
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
        addSubview(underLineView)
        addSubview(ageCheckButton)
        addSubview(termsCheckButton)
        addSubview(privacyCheckButton)
        addSubview(marketingCheckButton)
        
        setupLayout()
        setupBinding()
    }
    
    func setupLayout() {
        allCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(allCheckButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        ageCheckButton.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        termsCheckButton.snp.makeConstraints {
            $0.top.equalTo(ageCheckButton.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        privacyCheckButton.snp.makeConstraints {
            $0.top.equalTo(termsCheckButton.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(19.04)
        }
        
        marketingCheckButton.snp.makeConstraints {
            $0.top.equalTo(privacyCheckButton.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(19.04)
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

//
//  CreateMeetViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/07/19.
//

import UIKit
import RxSwift
import RxCocoa

class CreateMeetViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.67
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    private let headerLabel = UILabel().then {
        $0.text = "개설할 동아리를\n소개해주세요!"
        $0.font = .pretendardMedium(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "동아리명"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "동아리명 입력"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.autocorrectionType = .no
        $0.addLeftPadding()
    }
    
    private let noticeTitleLabel = UILabel().then {
        $0.text = "1~15(공백포함) 이내 한글, 영문, 숫자 사용 가능"
        $0.font = .pretendardMedium(size: 12)
        $0.textColor = .ptGray02
    }
    
    private let introduceLabel = UILabel().then {
        $0.text = "한 줄 소개"
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 14)
    }
    
    private let introduceTextField = UITextField().then {
        $0.placeholder = "한 줄 소개 입력(15자 이내)"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.autocorrectionType = .no
        $0.addLeftPadding()
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardSemiBold(size: 16)
        $0.backgroundColor = .ptGray03
        $0.layer.borderColor = UIColor.ptGray02.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = false
        $0.rx.tap
            .bind {
                self.nextButtonDidTap()
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavbar()
    }
    
    private func configureNavbar() {
        let backIcon = UIImage.ptImage(.backIcon)
        let leftButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(backButtonDidTap))
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    private func nextButtonDidTap() {
        print("DEBUG: NextButton did tap")
    }
    
    private func limitText(_ textField: UITextField, _ maxNumber: Int) {
        textField.rx.text.orEmpty
            .map { $0.count <= maxNumber }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isEditable in
                if !isEditable {
                    textField.deleteBackward()
                }
            }).disposed(by: disposeBag)
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(noticeTitleLabel)
        view.addSubview(introduceLabel)
        view.addSubview(introduceTextField)
        view.addSubview(nextButton)
    }
    
    override func setupLayouts() {
        progressbar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            $0.height.equalTo(4)
        }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalTo(view).offset(20)
            $0.top.equalTo(progressbar.snp.bottom).offset(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (view.frame.height / 812))
        }
        
        noticeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(24)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(20)
        }
        
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(57 * (view.frame.height / 812))
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56 * view.frame.height/812)
        }
    }
    
    override func setupBinding() {
        limitText(titleTextField, 15)
        limitText(introduceTextField, 15)
    }
}


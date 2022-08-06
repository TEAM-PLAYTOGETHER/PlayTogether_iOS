//
//  PopUpViewController.swift
//  PlayTogether
//
//  Created by 이지석 on 2022/08/03.
//

import UIKit
import RxSwift

enum popupType {
    case oneButton
    case twoButton
}

protocol PopUpConfirmDelegate: class {
    func confirmButtonDidTap()
}

class PopUpViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    weak var delegate: PopUpConfirmDelegate?
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = UIColor.ptBlack01.cgColor
        $0.layer.borderWidth = 1
        $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private lazy var noticeLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 16)
        $0.textColor = .ptBlack01
        $0.text = noticeTitle
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.borderColor = UIColor.ptBlack01.cgColor
        $0.layer.borderWidth = 1
        $0.spacing = 1
        $0.backgroundColor = .ptBlack01
    }
    
    private lazy var firstButton = UIButton().then {
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 14)
        $0.backgroundColor = .ptGreen
        
        switch popupViewType {
        case .oneButton: $0.setTitle("확인", for: .normal)
        case .twoButton: $0.setTitle("취소", for: .normal)
        }
        
    }
    
    private lazy var secondButton = UIButton().then {
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 14)
        $0.backgroundColor = .ptGreen
        switch popupViewType {
        case .oneButton: return
        case .twoButton: $0.setTitle("확인", for: .normal)
        }
    }
    
    private var noticeTitle: String = ""
    private var popupViewType: popupType
    
    init(title: String, viewType: popupType) {
        self.noticeTitle = title
        self.popupViewType = viewType
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        setupBinding()
    }
    
    private func setupViews() {
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.addSubview(containerView)
        
        containerView.addSubview(containerStackView)
        
        containerStackView.addSubview(noticeLabel)
        containerStackView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(firstButton)
        buttonStackView.addArrangedSubview(secondButton)
        
        switch popupViewType {
        case .oneButton: buttonStackView.removeArrangedSubview(secondButton)
        case .twoButton: break
        }
    }
    
    private func setupLayouts() {
        let containerViewHeight = 188 * (UIScreen.main.bounds.height / 812)
        let buttonStackViewHeight = 51 * (UIScreen.main.bounds.height / 812)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(containerViewHeight)
        }
        
        containerStackView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints {
            let height = (containerViewHeight - buttonStackViewHeight) / 2
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(height)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(buttonStackViewHeight)
        }
        
        switch popupViewType {
        case .oneButton:
            firstButton.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
            }
            
        case .twoButton:
            let width = containerView.frame.width
            firstButton.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
                $0.width.equalTo(width)
            }
            
            secondButton.snp.makeConstraints {
                $0.top.trailing.equalToSuperview()
                $0.width.equalTo(width)
            }
        }
    }
    
    private func setupBinding() {
        firstButton.rx.tap
            .bind(onNext: {[weak self] in
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        secondButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: {
                    self?.delegate?.confirmButtonDidTap()
                })
            }).disposed(by: disposeBag)
    }
    
}

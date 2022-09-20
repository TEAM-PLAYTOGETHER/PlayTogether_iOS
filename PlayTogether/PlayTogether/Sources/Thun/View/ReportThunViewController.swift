//
//  ReportThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/09/19.
//

import UIKit
import RxSwift
import RxCocoa

class ReportThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.setTitleColor(.ptGreen, for: .selected)
        $0.titleLabel?.font = .pretendardBold(size: 16)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "게시글을 신고하는 이유에 대해 알려주세요."
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private lazy var textView = UITextView().then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardRegular(size: 14)
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        $0.isScrollEnabled = false
        $0.backgroundColor = .ptGray04
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptGray03.cgColor
        $0.delegate = self
    }
    
    override func setupViews() {
        tabBarController?.tabBar.isHidden = true // TODO: - 이거는 지워주기
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "게시글 신고"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
    }
    
    override func setupLayouts() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo((UIScreen.main.bounds.height/812)*440)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                guard !self.completeButton.isSelected else {
                    print("다음화면으로 넘어가라")
                    return
                }
            })
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                guard $0.count > 0 else {
                    self.completeButton.isSelected = false
                    return
                }
                self.completeButton.isSelected = true
            })
            .disposed(by: disposeBag)
    }
}

extension ReportThunViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let height = (UIScreen.main.bounds.height/812)*440
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { constraints in
            if !(estimateSize.height <= height) {
                if constraints.firstAttribute == .height {
                    constraints.constant = estimateSize.height
                }
            }
        }
    }
}

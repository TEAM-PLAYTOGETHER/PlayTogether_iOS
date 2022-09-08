//
//  ViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit
import RxSwift

class OnboardingViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    
    private let progressbar = UIProgressView().then {
        $0.progress = 0.25
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let headerLabel = UILabel().then {
        $0.text = "번개를\n시작해볼까요?"
        $0.font = .pretendardMedium(size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    private let orderLabel = UILabel().then {
        $0.text = "개설과 참여 중 선택해주세요"
        $0.font = .pretendardRegular(size: 14)
        $0.textColor = .ptBlack02
    }
    
    private lazy var choiceCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = 335 * (view.frame.width / 375)
        let height = 86 * (view.frame.height / 812)
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        
        $0.collectionViewLayout = collectionViewFlowLayout
        $0.backgroundColor = .white
        $0.delegate = self
        $0.dataSource = self
        $0.register(ChoiceCell.self, forCellWithReuseIdentifier: "ChoiceCell")
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setupBottomButtonUI(title: "다음", size: 16)
        $0.isButtonEnableUI(check: false)
    }
    
    private let leftButtonItem = UIBarButtonItem(image: UIImage.ptImage(.backIcon), style: .plain, target: CheckTermsServiceViewController.self, action: nil)

    private let viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNaigationvBar()
    }
    
    private func configureNaigationvBar() {
        navigationItem.leftBarButtonItem = leftButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(orderLabel)
        view.addSubview(choiceCollectionView)
        view.addSubview(nextButton)
    }   
    
    override func setupLayouts() {
        progressbar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.height.equalTo(4)
        }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(progressbar.snp.bottom).offset(24)
        }
        
        orderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
        }
        
        choiceCollectionView.snp.makeConstraints {
            let height = ((view.frame.height / 812) * 86) * 2 + 10
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(orderLabel.snp.bottom).offset(28)
            $0.height.equalTo(height)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56 * view.frame.height/812)
        }
    }
    
    override func setupBinding() {
        leftButtonItem.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
      
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let isCreate = OnboardingDataModel.shared.isCreated else { return }
                let controller  = isCreate ? CreateMeetViewController() : InvitationCodeViewController()
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ChoiceCell",
            for: indexPath
        ) as? ChoiceCell else { return UICollectionViewCell() }
        
        indexPath.row == 0 ?
        cell.configureCell("개설", "번개를 열 동아리나 단체를 개설해요!") : cell.configureCell("참여", "개설된 동아리나 단체에 참여해요!")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextButton.isButtonEnableUI(check: true)
        OnboardingDataModel.shared.isCreated = indexPath.row == 0 ? true : false
    }
}

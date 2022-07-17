//
//  ViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit
import SnapKit
import Then

class OnboardingViewController: BaseViewController {
    
    // MARK: - Properties
    
    let headerView = UIView().then {
        $0.backgroundColor = .black
    }
    
    let progressbar = UIProgressView().then {
        $0.progress = 0.33
        $0.progressTintColor = .ptGreen
        $0.backgroundColor = .ptGray03
    }
    
    let headerLabel = UILabel().then {
        $0.text = "번개를\n시작해볼까요?"
        $0.font = UIFont(name: "Pretendard-Medium", size: 22)
        $0.textColor = .ptBlack01
        $0.numberOfLines = 0
    }
    
    let orderLabel = UILabel().then {
        $0.text = "개설과 참여 중 선택해주세요"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.textColor = .ptBlack02
    }
    
    lazy var choiceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .white
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 16)
        $0.backgroundColor = .ptGray03
        $0.layer.borderColor = UIColor.ptGray02.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    var index: Int = 0
    let viewModel = OnboardingViewModel()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
    
    // MARK: - Selector
    
    @objc func nextButtonDidTap() {
        print("DEBUG: nextButton did tapped")
    }
    
    
    // MARK: - Functions
    
    override func setupViews() {
        view.addSubview(headerView)
        view.addSubview(progressbar)
        view.addSubview(headerLabel)
        view.addSubview(orderLabel)
        view.addSubview(choiceCollectionView)
        view.addSubview(nextButton)
    }
    
    override func setupLayouts() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view).inset(0)
            make.height.equalTo(97)
        }
        
        progressbar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).offset(0)
            make.top.equalTo(headerView.snp.bottom).offset(0)
            make.height.equalTo(4)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(20)
            make.top.equalTo(progressbar.snp.bottom).offset(24)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(20)
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
        }
        
        choiceCollectionView.snp.makeConstraints { make in
            let height = ((view.frame.height / 812) * 86) * 2 + 10
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).offset(-20)
            make.top.equalTo(orderLabel.snp.bottom).offset(28)
            make.height.equalTo(height)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.bottom.equalTo(view).inset(40)
            make.height.equalTo(56 * view.frame.height/812)
        }
    }
    
    override func setupBinding() {
        choiceCollectionView.delegate = self
        choiceCollectionView.dataSource = self
        choiceCollectionView.register(ChoiceCell.self, forCellWithReuseIdentifier: "ChoiceCell")
    }
}


// MARK: - UICollectionVeiw Delegate & FlowLayout

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = choiceCollectionView.frame.width
        let height = view.frame.height
        return viewModel.sizeForItemAt(width, height)
    }
}


// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoiceCell", for: indexPath) as? ChoiceCell else { return UICollectionViewCell() }
        let data = viewModel.configureCellData(indexPath.row)
        cell.titleLabel.text = data[0]
        cell.subTitleLabel.text = data[1]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let items = collectionView.indexPathsForSelectedItems {
            if viewModel.cellWasTapped(items.count) {
                nextButton.isEnabled = true
                nextButton.setTitleColor(.ptBlack01, for: .normal)
                nextButton.backgroundColor = .ptGreen
                nextButton.layer.borderColor = UIColor.ptBlack01.cgColor
            }
        }
        
        print("DEBUG: Cell is clicked by \(indexPath.row)")
    }

}

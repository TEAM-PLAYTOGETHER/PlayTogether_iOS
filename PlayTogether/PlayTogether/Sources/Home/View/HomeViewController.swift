//
//  HomeViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import RxSwift
import UIKit

final class HomeViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = HomeViewModel()
    
    private let leftBarItem = UIButton().then {
        $0.setTitle("SOPT", for: .normal) // TODO: 추후 삭제 예정
        $0.setTitleColor(.ptGreen, for: .normal)
        $0.setImage(.ptImage(.showIcon), for: .normal)
        $0.titleLabel?.font = .pretendardBold(size: 20)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    private let rightBarItem = UIButton().then {
        $0.setImage(.ptImage(.searchIcon), for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let thunButton = UIButton().then {
        $0.setImage(.ptImage(.floatingIcon), for: .normal)
    }
    
    private let categoryLabel = UILabel().then {
        $0.text = "번개 카테고리"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    private let eatButton = UIButton().then {
        $0.setImage(.ptImage(.eatIcon), for: .normal)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.ptBlack02.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private let eatLabel = UILabel().then {
        $0.text = "먹을래"
        $0.textColor = .ptBlack01
        $0.font = .pretendardSemiBold(size: 14)
    }
    
    private let goButton = UIButton().then {
        $0.setImage(.ptImage(.goIcon), for: .normal)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.ptBlack02.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private let goLabel = UILabel().then {
        $0.text = "갈래"
        $0.textColor = .ptBlack01
        $0.font = .pretendardSemiBold(size: 14)
    }
    
    private let doButton = UIButton().then {
        $0.setImage(.ptImage(.doIcon), for: .normal)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.ptBlack02.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private let doLabel = UILabel().then {
        $0.text = "할래"
        $0.textColor = .ptBlack01
        $0.font = .pretendardSemiBold(size: 14)
    }
    
    private let devideView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private let hotLabel = UILabel().then {
        $0.text = "HOT"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    private let newLabel = UILabel().then {
        $0.text = "NEW"
        $0.font = .pretendardBold(size: 20)
        $0.textColor = .ptBlack01
    }
    
    private lazy var hotCollectionViewLayout = UICollectionViewFlowLayout().then {
        let widthSize = UIScreen.main.bounds.width * 0.76
        let heightSize = UIScreen.main.bounds.height * 0.16
        $0.minimumLineSpacing = 10
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: widthSize, height: heightSize)
    }
    
    private lazy var newCollectionViewLayout = UICollectionViewFlowLayout().then {
        let widthSize = UIScreen.main.bounds.width * 0.76
        let heightSize = UIScreen.main.bounds.height * 0.16
        $0.minimumLineSpacing = 10
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: widthSize, height: heightSize)
    }
    
    private let hotEmptyView = HomeEmptyView()
    private let newEmptyView = HomeEmptyView()
    
    private lazy var hotCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: hotCollectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.bounces = false
        $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private lazy var newCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: newCollectionViewLayout
    ).then {
        $0.backgroundColor = .white
        $0.bounces = false
        $0.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarItem)
        
        view.addSubview(scrollView)
        view.addSubview(thunButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(eatButton)
        contentView.addSubview(eatLabel)
        contentView.addSubview(goButton)
        contentView.addSubview(goLabel)
        contentView.addSubview(doButton)
        contentView.addSubview(doLabel)
        contentView.addSubview(devideView)
        contentView.addSubview(hotLabel)
        contentView.addSubview(hotEmptyView)
        contentView.addSubview(hotCollectionView)
        contentView.addSubview(newLabel)
        contentView.addSubview(newEmptyView)
        contentView.addSubview(newCollectionView)
    }
    
    override func setupLayouts() {
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        
        thunButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(tabBarHeight+16)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        eatButton.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        eatLabel.snp.makeConstraints {
            $0.top.equalTo(eatButton.snp.bottom).offset(10)
            $0.centerX.equalTo(eatButton)
        }
        
        goButton.snp.makeConstraints {
            $0.top.equalTo(eatButton)
            $0.centerX.equalToSuperview()
        }
        
        goLabel.snp.makeConstraints {
            $0.top.equalTo(eatLabel)
            $0.centerX.equalTo(goButton)
        }
        
        doButton.snp.makeConstraints {
            $0.top.equalTo(eatButton)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        doLabel.snp.makeConstraints {
            $0.top.equalTo(eatLabel)
            $0.centerX.equalTo(doButton)
        }
        
        devideView.snp.makeConstraints {
            $0.top.equalTo(goLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        hotLabel.snp.makeConstraints {
            $0.top.equalTo(devideView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        hotEmptyView.snp.makeConstraints {
            $0.top.equalTo(hotLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.16)
        }
        
        hotCollectionView.snp.makeConstraints {
            $0.top.height.equalTo(hotEmptyView)
            $0.leading.trailing.equalToSuperview()
        }
        
        newLabel.snp.makeConstraints {
            $0.top.equalTo(hotCollectionView.snp.bottom).offset(48)
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        newEmptyView.snp.makeConstraints {
            $0.top.equalTo(newLabel.snp.bottom).offset(12)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset((-(tabBarHeight+48)))
        }
        
        newCollectionView.snp.makeConstraints {
            $0.top.height.bottom.equalTo(newEmptyView)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel.isEmptyHotThun
            .bind(to: hotCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hotThunList
            .bind(to: self.hotCollectionView.rx.items) { _, row, item -> UICollectionViewCell in
                guard let cell = self.hotCollectionView.dequeueReusableCell(
                    withReuseIdentifier: "HomeCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? HomeCollectionViewCell,
                      let item = item
                else { return UICollectionViewCell() }
                
                cell.setupData(item.title, item.category, item.nowMemberCount,
                               item.totalMemberCount, item.date, item.place, item.time)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        viewModel.isEmptyNewThun
            .bind(to: newCollectionView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.newThunList
            .bind(to: self.newCollectionView.rx.items) { _, row, item -> UICollectionViewCell in
                guard let cell = self.newCollectionView.dequeueReusableCell(
                    withReuseIdentifier: "HomeCollectionViewCell",
                    for: IndexPath(row: row, section: 0)
                ) as? HomeCollectionViewCell,
                      let item = item
                else { return UICollectionViewCell() }
                
                cell.setupData(item.title, item.category, item.nowMemberCount,
                               item.totalMemberCount, item.date, item.place, item.time)
                return cell
            }
            .disposed(by: self.disposeBag)
        
        thunButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.pushViewController(CreateThunViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        eatButton.rx.tap
            .bind { [weak self] in
                let vc = ThunListViewController(currentPageIndex: 0, index: 0)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)
        
        goButton.rx.tap
            .bind { [weak self] in
                let vc = ThunListViewController(currentPageIndex: 1, index: 1)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)
        
        doButton.rx.tap
            .bind { [weak self] in
                let vc = ThunListViewController(currentPageIndex: 2, index: 2)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.tabBarController?.tabBar.isHidden = true
            }
            .disposed(by: disposeBag)
        
        hotCollectionView.rx.modelSelected(HomeResponseList.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(
                    EnterDetailThunViewController(
                        lightID: $0.lightID), animated: true)
            })
            .disposed(by: disposeBag)
        
        newCollectionView.rx.modelSelected(HomeResponseList.self)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(
                    EnterDetailThunViewController(
                        lightID: $0.lightID), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

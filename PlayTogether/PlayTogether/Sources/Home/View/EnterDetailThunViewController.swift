//
//  DetailThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/12.
//

import UIKit
import RxSwift
import SnapKit
import Then

class EnterDetailThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = DetailThunViewModel()
    private let likeThunViewModel = LikeThunViewModel()
    private let cancelViewModel = CancelThunViewModel()
    private let existThunViewModel = ExistThunViewModel()
    var lightId: Int?
    var imageCount: Int?
    
    init(lightID: Int) {
        self.lightId = lightID
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    
    private let enterButton = UIButton().then {
        $0.isButtonEnableUI(check: true)
    }
    
    private let contentView = UIView()
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(.ptImage(.navLikeDefaultIcon), for: .normal)
        $0.setImage(.ptImage(.navLikeFilledGreenIcon), for: .selected)
    }
    
    private let circleImageView = UIImageView().then {
        $0.image = .ptImage(.profileIcon)
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .pretendardBold(size: 14)
        $0.textColor = .ptBlack01
    }
    
    private let messageButton = UIButton().then {
        $0.setTitle("쪽지", for: .normal)
        $0.backgroundColor = .ptBlack02
        $0.titleLabel?.font = .pretendardMedium(size: 12)
        $0.layer.cornerRadius = 14
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private let blackView = UIView().then {
        $0.backgroundColor = .ptBlack01
        $0.layer.cornerRadius = 10
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .ptGreen
        $0.font = .pretendardBold(size: 20)
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .white
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .white
    }
    
    private let placeLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .white
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .white
    }
    
    private lazy var labelStackView = UIStackView(
        arrangedSubviews:[dateLabel,timeLabel,placeLabel,categoryLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 22
    }
    
    private let dashedLineView = UIView().then {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: UIScreen.main.bounds.width, y: 0)])
        shapeLayer.path = path
        $0.layer.addSublayer(shapeLayer)
    }
    
    private let textInfoLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.font = .pretendardRegular(size: 14)
    }
    
    private lazy var imageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width / 375) * 273
        let height = (UIScreen.main.bounds.height / 812) * 91
        collectionViewLayout.itemSize = CGSize(width: width/3, height: height)
        collectionViewLayout.minimumLineSpacing = 15
        $0.collectionViewLayout = collectionViewLayout
        
        $0.backgroundColor = .ptBlack01
        $0.register(
            DetailThunImageCollectionViewCell.self,
            forCellWithReuseIdentifier: "DetailThunImageCollectionViewCell"
        )
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let alertButton = UIButton().then {
        $0.setTitle("게시글 신고", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 12)
        $0.setUnderline()
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        
        view.addSubview(scrollView)
        view.addSubview(enterButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(circleImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(messageButton)
        contentView.addSubview(underLineView)
        contentView.addSubview(blackView)
        contentView.addSubview(alertButton)
        
        blackView.addSubview(titleLabel)
        blackView.addSubview(dateLabel)
        blackView.addSubview(timeLabel)
        blackView.addSubview(placeLabel)
        blackView.addSubview(categoryLabel)
        blackView.addSubview(labelStackView)
        blackView.addSubview(dashedLineView)
        blackView.addSubview(textInfoLabel)
        blackView.addSubview(imageCollectionView)
    }
    
    override func setupLayouts() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        enterButton.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56 * UIScreen.main.bounds.height/812)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        circleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(circleImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(circleImageView.snp.centerY)
        }
        
        messageButton.snp.makeConstraints {
            $0.centerY.equalTo(nicknameLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-27)
            $0.size.equalTo(CGSize(width: 52, height: 26))
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(circleImageView.snp.bottom).offset(20)
            $0.leading.equalTo(circleImageView.snp.leading)
            $0.trailing.equalTo(messageButton.snp.trailing).offset(7)
            $0.height.equalTo(1)
        }
        
        blackView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(underLineView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        dashedLineView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(textInfoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(textInfoLabel)
            $0.height.equalTo((UIScreen.main.bounds.height / 812) * 91)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        textInfoLabel.snp.makeConstraints {
            if imageCollectionView.frame.height == 1 {
                $0.top.equalTo(dashedLineView.snp.bottom).offset(20)
                $0.leading.equalTo(labelStackView.snp.leading)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().inset(20)
            } else {
                $0.top.equalTo(dashedLineView.snp.bottom).offset(20)
                $0.leading.equalTo(labelStackView.snp.leading)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }
        
        alertButton.snp.makeConstraints {
            $0.top.equalTo(blackView.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-33)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel.getDetailThunList(lightId: lightId ?? -1) { response in
            let nameResponse = response[0].organizer
            self.setupData(
                response[0].title,
                response[0].date ?? "날짜미정",
                response[0].time ?? "시간미정",
                response[0].datumDescription ?? "",
                response[0].place ?? "장소미정",
                response[0].category,
                nameResponse[0].name,
                response[0].peopleCnt ?? 0,
                response[0].lightMemberCnt
            )
        }
        
        likeThunViewModel.getExistLikeThun(lightId: lightId ?? -1) {
            self.likeButton.isSelected = $0
        }
        
        viewModel.getImageList(lightId: lightId ?? -1) { image in
            Observable.of([image])
                .bind(to: self.imageCollectionView.rx.items) {
                    _, row, item -> UICollectionViewCell in
                    guard let cell = self.imageCollectionView.dequeueReusableCell(
                        withReuseIdentifier: "DetailThunImageCollectionViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as? DetailThunImageCollectionViewCell
                    else { return UICollectionViewCell() }
                    
                    if item.isEmpty {
                        self.imageCollectionView.snp.updateConstraints {
                            $0.top.equalTo(self.textInfoLabel.snp.bottom)
                            $0.height.equalTo(1)
                        }
                    }
                    cell.imageView.loadImage(url: image)
                    self.imageCount = [image].count
                    return cell
                }
                .disposed(by: self.disposeBag)
        }
    
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.likeThunViewModel.postLikeThun(lightId: self?.lightId ?? -1) {
                    self?.likeButton.isSelected = !$0
                }
            })
            .disposed(by: disposeBag)
        
        imageCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                let nextVC = SelectImageViewController(lightID: self?.lightId ?? -1, indexPath: indexPath.row, imageCount: self?.imageCount ?? 0)
                nextVC.modalPresentationStyle = .fullScreen
                self?.present(nextVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        enterButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                let popupViewController = PopUpViewController(title: "번개에 참여할까요?", viewType: .twoButton)
                self?.present(popupViewController, animated: false, completion: nil)
//                popupViewController.delegate = self
            })
            .disposed(by: disposeBag)
        
        existThunViewModel.getExistThun(lightId: lightId ?? -1) {_ in
            if self.existThunViewModel.isExistThun == true {
                self.enterButton.isHidden = true
                self.enterButton.snp.updateConstraints {
                    $0.height.equalTo(0)
                }
            } else {
                self.enterButton.isHidden = false
            }
        }
    }
}

extension EnterDetailThunViewController {
    func setupData(
        _ title: String,
        _ date: String,
        _ time: String,
        _ description: String,
        _ place: String,
        _ category: String,
        _ name: String,
        _ peopleCnt: Int,
        _ lightMemberCnt: Int
    ){
        let dateStr = date.replacingOccurrences(of: "-", with: ".")
        titleLabel.text = title
        dateLabel.text = "날짜  \(dateStr)"
        dateLabel.changeFontColor(targetString: "날짜", color: .ptGreen)
        timeLabel.text = "시간  \(time)"
        timeLabel.changeFontColor(targetString: "시간", color: .ptGreen)
        placeLabel.text = "장소  \(place)"
        placeLabel.changeFontColor(targetString: "장소", color: .ptGreen)
        categoryLabel.text = "카테고리  \(category)"
        categoryLabel.changeFontColor(targetString: "카테고리", color: .ptGreen)
        textInfoLabel.text = description
        nicknameLabel.text = name
        enterButton.setupBottomButtonUI(title: "신청하기 (\(lightMemberCnt)/\(peopleCnt))", size: 16)
    }
}

//extension EnterDetailThunViewController: PopUpConfirmDelegate {
//    func oneButtonDidTap() {}
//    func firstButtonDidTap() {}
//    func secondButtonDidTap() {
//        cancelViewModel.postCancelThun(lightId: lightId ?? -1) {_ in
//            self.navigationController?.pushViewController(CompleteThunViewController(
//                lightID: self.lightId ?? -1,
//                completeText: "번개 신청을\n완료했어요!"
//            ),animated: true)
//        }
//    }
//}

//
//  OpenedDetailThunViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/27.
//

import UIKit
import RxSwift
import SnapKit
import Then
import RxCocoa

class OpenedDetailThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = DetailThunViewModel()
    private let deleteThunViewModel = DeleteThunViewModel()
    private let superViewModel: ThunViewModel?
    var lightId: Int?
    
    init(lightID: Int, superViewModel: ThunViewModel) {
        self.lightId = lightID
        self.superViewModel = superViewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let navigationBarView = UIView().then {
        $0.backgroundColor = .ptBlack01
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let optionButton = UIButton().then {
        $0.setImage(.ptImage(.optionIcon), for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
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
    
    private lazy var labelStackView = UIStackView(arrangedSubviews:[dateLabel,timeLabel,placeLabel,categoryLabel]).then {
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
    
    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width / 375) * 273
        let height = (UIScreen.main.bounds.height / 812) * 91
        collectionViewLayout.itemSize = CGSize(width: width/3, height: height)
        collectionViewLayout.minimumLineSpacing = 15
        $0.collectionViewLayout = collectionViewLayout
        
        $0.backgroundColor = .ptBlack01
        $0.register(SubmittedDetailThunCollectionViewCell.self, forCellWithReuseIdentifier: "SubmittedDetailThunCollectionViewCell")
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let grayLineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private var memberCntLabel = UILabel().then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 16)
    }
    
    private lazy var memberTableView = UITableView().then {
        $0.register(SubmittedDetailThunTableViewCell.self, forCellReuseIdentifier: SubmittedDetailThunTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = (UIScreen.main.bounds.height / 812) * 60
        $0.isScrollEnabled = false
    }
    
    private let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 14)
        let border = UIView()
        border.backgroundColor = .ptBlack01
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: $0.frame.width, height: 1)
        $0.addSubview(border)
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 14)
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [editButton,deleteButton]).then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptBlack01.cgColor
        $0.layer.cornerRadius = 5
        $0.distribution = .fillEqually
        $0.isHidden = true
    }
        
    override func setupViews() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(navigationBarView)
        view.addSubview(scrollView)
        view.addSubview(buttonStackView)
        
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(optionButton)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(circleImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(messageButton)
        contentView.addSubview(underLineView)
        contentView.addSubview(blackView)
        contentView.addSubview(grayLineView)
        contentView.addSubview(memberCntLabel)
        contentView.addSubview(memberTableView)
        
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
        navigationBarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            let height = UIScreen.main.bounds.height/812 * 44
            let navigationBarHeight = navigationController?.navigationBar.frame.height
            $0.height.equalTo(height+navigationBarHeight!)
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.leading.equalTo(navigationBarView.snp.leading).offset(18)
        }
        
        optionButton.snp.makeConstraints {
            $0.bottom.equalTo(backButton.snp.bottom)
            $0.trailing.equalTo(navigationBarView.snp.trailing).offset(-20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-54)
            $0.bottom.equalTo(navigationBarView.snp.bottom).offset(40)
            $0.width.equalTo((UIScreen.main.bounds.width/375)*113)
            $0.height.equalTo((UIScreen.main.bounds.height/812)*82)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
            $0.top.equalTo(textInfoLabel.snp.bottom)
            $0.leading.trailing.equalTo(textInfoLabel)
            $0.height.equalTo(1)
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
        
        grayLineView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 8))
            $0.top.equalTo(blackView.snp.bottom).offset(40)
        }
        
        memberCntLabel.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(blackView)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(memberCntLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(blackView)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel.getDetailThunList(lightId: lightId ?? -1) { response in
            let nameResponse = response[0].organizer
            self.setupData(
                response[0].title,
                response[0].date ?? "날짜 미정",
                response[0].time ?? "시간 미정",
                response[0].datumDescription ?? "",
                response[0].place ?? "장소 미정",
                response[0].category,
                nameResponse[0].name,
                response[0].peopleCnt ?? 0,
                response[0].lightMemberCnt
            )
        }
        
        viewModel.getMemberList(lightId: lightId ?? -1) { member in
            Observable.of(member)
                .bind(to: self.memberTableView.rx.items) { _, row, item -> UITableViewCell in
                    guard let cell = self.memberTableView.dequeueReusableCell(
                        withIdentifier: "SubmittedDetailThunTableViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as? SubmittedDetailThunTableViewCell else { return UITableViewCell() }
                    
                    self.memberTableView.snp.updateConstraints {
                        $0.height.equalTo(self.memberTableView.contentSize.height)
                    }
                    cell.setupData(item.name)
                    return cell
                }
                .disposed(by: self.disposeBag)
        }
        
        viewModel.getImageList(lightId: lightId ?? -1) { image in
            Observable.just([image])
                .bind(to: self.imageCollectionView.rx.items) {
                    _, row, item -> UICollectionViewCell in
                    guard let cell = self.imageCollectionView.dequeueReusableCell(
                        withReuseIdentifier: "SubmittedDetailThunCollectionViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as? SubmittedDetailThunCollectionViewCell
                    else { return UICollectionViewCell() }

                    if item.isEmpty == false {
                        self.imageCollectionView.snp.updateConstraints {
                            $0.top.equalTo(self.textInfoLabel.snp.bottom).offset(20)
                            $0.height.equalTo((UIScreen.main.bounds.height / 812) * 91)
                        }
                        cell.imageView.loadImage(url: image)
                    }
                    return cell
                }
                .disposed(by: self.disposeBag)
        }
        
        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.navigationController?.navigationBar.isHidden = false
                self?.tabBarController?.tabBar.isHidden = false
            }
            .disposed(by: disposeBag)
        
        optionButton.rx.tap
            .bind { [weak self] in
                if self?.buttonStackView.isHidden == true {
                    self?.buttonStackView.isHidden = false
                } else {
                    self?.buttonStackView.isHidden =  true
                }
            }
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind { [weak self] in
                self?.buttonStackView.isHidden = true
                print("수정버튼") // TODO: - 수정부분 서버 완료되면 연결할 것
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind { [weak self] in
                self?.buttonStackView.isHidden = true
                let popupViewController = PopUpViewController(title: "게시글을 삭제할까요?", viewType: .twoButton)
                self?.present(popupViewController, animated: false, completion: nil)
                popupViewController.delegate = self
            }
            .disposed(by: disposeBag)
    }
}

extension OpenedDetailThunViewController {
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
        memberCntLabel.text = "번개 참여자 (\(lightMemberCnt)/\(peopleCnt))"
    }
}

extension OpenedDetailThunViewController: PopUpConfirmDelegate {
    func oneButtonDidTap() {
        guard let originData = try? superViewModel?.openedThunList.value() else { return }
        superViewModel?.openedThunList.onNext(originData.filter { $0?.lightID != self.lightId })
        navigationController?.popToRootViewController(animated: true)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    func firstButtonDidTap() {}
    
    func secondButtonDidTap() {
        deleteThunViewModel.postDeleteThun(lightId: lightId ?? -1) { response in
            let popupViewController = PopUpViewController(
                title: "게시글이 삭제되었습니다.",
                viewType: .oneButton
            )
            self.present(popupViewController, animated: false, completion: nil)
            popupViewController.delegate = self
        }
    }
}


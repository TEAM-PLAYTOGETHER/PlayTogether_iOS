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

class SubmittedDetailThunViewController: BaseViewController {
    
    init(lightID: Int) {
        super.init()
        self.lightId = lightID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var disposeBag = DisposeBag()
    private let viewModel = SubmittedDetailThunViewModel()
    var img = ["임시데스네"]
    var lightId: Int?
    var memberCnt: Int?
    
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
    
    private lazy var stackView = UIStackView(arrangedSubviews:[dateLabel,timeLabel,placeLabel,categoryLabel]).then {
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
    
    private lazy var layout = UICollectionViewFlowLayout().then {
        let widthSize = 91 * (UIScreen.main.bounds.width/375)
        let heightSize = 91 * (UIScreen.main.bounds.height/812)
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: widthSize, height: heightSize)
    }

    private lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .ptBlack01
        $0.register(SubmittedDetailThunCollectionViewCell.self, forCellWithReuseIdentifier: "SubmittedDetailThunCollectionViewCell")
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
    }

    private let alertButton = UIButton().then {
        $0.setTitle("게시글 신고", for: .normal)
        $0.setTitleColor(.ptGray01, for: .normal)
        $0.titleLabel?.font = .pretendardRegular(size: 12)
        $0.setUnderline()
    }
    
    private let grayLineView = UIView().then {
        $0.backgroundColor = .ptGray03
    }
    
    private lazy var memberTableView = UITableView().then {
        $0.register(SubmittedDetailThunTableViewCell.self, forCellReuseIdentifier: SubmittedDetailThunTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 60
        $0.isScrollEnabled = false
        $0.backgroundColor = .red
    }

    private var headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40*(UIScreen.main.bounds.height/812))).then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 16)
    }

    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40*(UIScreen.main.bounds.height/812)))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNaigationvBar()
    }
    
    private func configureNaigationvBar() {
        let navigationBarController = navigationController?.navigationBar
        navigationBarController?.isTranslucent = false
        navigationBarController?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: .ptImage(.backIcon), style: .plain, target: self, action: #selector(backButtonDidTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "신청 취소", style: .plain, target: self, action: #selector(cancelButtonDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .ptGreen
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.pretendardRegular(size: 16)], for: .normal)
    }
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func cancelButtonDidTap() {
        print("신청취소")
    }

    override func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        headerView.addSubview(headerLabel)
        memberTableView.tableHeaderView = headerView
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(circleImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(messageButton)
        contentView.addSubview(underLineView)
        contentView.addSubview(blackView)
        contentView.addSubview(grayLineView)
        contentView.addSubview(memberTableView)
        
        blackView.addSubview(titleLabel)
        blackView.addSubview(dateLabel)
        blackView.addSubview(timeLabel)
        blackView.addSubview(placeLabel)
        blackView.addSubview(categoryLabel)
        blackView.addSubview(stackView)
        blackView.addSubview(dashedLineView)
        blackView.addSubview(textInfoLabel)
        blackView.addSubview(imageCollectionView)
        blackView.addSubview(alertButton)
    }
    
    override func setupLayouts() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        dashedLineView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        textInfoLabel.snp.makeConstraints {
            $0.top.equalTo(dashedLineView.snp.bottom).offset(20)
            $0.leading.equalTo(stackView.snp.leading)
            $0.trailing.equalToSuperview().offset(-16)
        }

        imageCollectionView.snp.makeConstraints {
            if img.count == 0 {
                imageCollectionView.isHidden = true
            } else {
                $0.top.equalTo(textInfoLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalTo(textInfoLabel)
                $0.height.equalTo(91*(UIScreen.main.bounds.height/812))
            }
        }

        alertButton.snp.makeConstraints {
            if imageCollectionView.isHidden {
                $0.top.equalTo(textInfoLabel.snp.bottom).offset(20)
                $0.trailing.equalToSuperview().offset(-25)
                $0.bottom.equalToSuperview().offset(-20)
            } else {
                $0.top.equalTo(imageCollectionView.snp.bottom).offset(15)
                $0.trailing.equalToSuperview().offset(-25)
                $0.bottom.equalToSuperview().offset(-20)
            }
        }
        
        grayLineView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 8))
            $0.top.equalTo(blackView.snp.bottom).offset(40)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(grayLineView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(blackView)
            $0.height.equalTo(memberTableView.contentSize.height)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        viewModel.getDetailThunList(lightId: lightId ?? -1) { response in
            let nameResponse = response[0].organizer
            self.setupData(response[0].title, response[0].date, response[0].time, response[0].datumDescription, response[0].place, response[0].category, nameResponse[0].name, response[0].peopleCnt, response[0].lightMemberCnt)
        }
        
        viewModel.getMemberList(lightId: lightId ?? -1) { member in
            Observable.of(member)
                .bind(to: self.memberTableView.rx.items) { _, row, item -> UITableViewCell in
                    guard let cell = self.memberTableView.dequeueReusableCell(
                        withIdentifier: "SubmittedDetailThunTableViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as? SubmittedDetailThunTableViewCell else { return UITableViewCell() }
                    cell.setupData(item.name)
                    return cell
                }
                .disposed(by: self.disposeBag)
        }
    }
}

extension SubmittedDetailThunViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if img.count == 0 {
            return 0
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubmittedDetailThunCollectionViewCell", for: indexPath) as? SubmittedDetailThunCollectionViewCell else {return UICollectionViewCell()}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = ImageDetailViewController()
//        navigationController?.pushViewController(vc, animated: true)
//        navigationController?.isNavigationBarHidden = true
//        tabBarController?.tabBar.isHidden = true
    }
}

extension SubmittedDetailThunViewController {
    func setupData(
        _ title: String,_ date: String,_ time: String,_ description: String,_ place: String,_ category: String,_ name: String,_ peopleCnt: Int,_ lightMemberCnt: Int
    ){
        let dateStr = date.replacingOccurrences(of: "-", with: ".")
        titleLabel.text = title
        dateLabel.text = "날짜  \(dateStr)"
        dateLabel.asFontColor(targetString: "날짜", font: .pretendardRegular(size: 14), color: .ptGreen)
        timeLabel.text = "시간  \(time)"
        timeLabel.asFontColor(targetString: "시간", font: .pretendardRegular(size: 14), color: .ptGreen)
        placeLabel.text = "장소  \(place)"
        placeLabel.asFontColor(targetString: "장소", font: .pretendardRegular(size: 14), color: .ptGreen)
        categoryLabel.text = "카테고리  \(category)"
        categoryLabel.asFontColor(targetString: "카테고리", font: .pretendardRegular(size: 14), color: .ptGreen)
        textInfoLabel.text = description
        nicknameLabel.text = name
        headerLabel.text = "번개 참여자 (\(lightMemberCnt)/\(peopleCnt))"
    }
}

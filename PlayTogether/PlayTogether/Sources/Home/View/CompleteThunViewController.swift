import UIKit
import RxSwift

final class CompleteThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = DetailThunViewModel()
    private var submittedViewModel = SubmittedThunViewModel()
    var lightId: Int?
    
    init(lightID: Int, completeText: String) {
        self.lightId = lightID
        self.completeLabel.text = completeText
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }

    private let contentView = UIView()

    private let blackBackgroundView = UIView().then {
        $0.backgroundColor = .ptBlack01
    }

    private let exitButton = UIButton().then {
        $0.setImage(.ptImage(.clearIcon), for: .normal)
    }

    private let completeLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .pretendardRegular(size: 22)
        $0.textColor = .white
    }

    private let borderView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ptBlack01.cgColor
        $0.layer.cornerRadius = 10
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 20)
    }

    private let dateLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }

    private let timeLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }

    private let placeLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }

    private let categoryLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }

    private let organizerNameLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
    }

    private lazy var labelStackView = UIStackView(arrangedSubviews:[dateLabel,timeLabel,placeLabel,categoryLabel,organizerNameLabel]).then {
        $0.axis = .vertical
        $0.spacing = 22
    }

    private let dashedLineView = UIView().then {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.ptBlack01.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [2, 2]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: (UIScreen.main.bounds.width / 375) * 335, y: 0)])
        shapeLayer.path = path
        $0.layer.addSublayer(shapeLayer)
    }

    private let moreButton = UIButton().then {
        $0.setTitle("자세히 보기", for: .normal)
        $0.setTitleColor(.ptBlack01, for: .normal)
        $0.titleLabel?.font = .pretendardMedium(size: 14)
    }

    private var memberCntLabel = UILabel().then {
        $0.textColor = .ptBlack01
        $0.font = .pretendardBold(size: 16)
    }

    private lazy var memberTableView = UITableView().then {
        $0.register(DetailThunMemberTableViewCell.self, forCellReuseIdentifier: DetailThunMemberTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = (UIScreen.main.bounds.height / 812) * 60
        $0.isScrollEnabled = false
    }
    
    override func setupViews() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
        
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(blackBackgroundView)
        contentView.addSubview(borderView)
        contentView.addSubview(memberCntLabel)
        contentView.addSubview(memberTableView)

        blackBackgroundView.addSubview(completeLabel)

        borderView.addSubview(titleLabel)
        borderView.addSubview(dateLabel)
        borderView.addSubview(timeLabel)
        borderView.addSubview(placeLabel)
        borderView.addSubview(categoryLabel)
        borderView.addSubview(organizerNameLabel)
        borderView.addSubview(labelStackView)
        borderView.addSubview(dashedLineView)
        borderView.addSubview(moreButton)
    }

    override func setupLayouts() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        blackBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.144)
        }

        completeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        borderView.snp.makeConstraints {
            $0.leading.equalTo(completeLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(blackBackgroundView.snp.bottom).offset(20)
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
            $0.trailing.leading.equalToSuperview()
        }

        moreButton.snp.makeConstraints {
            $0.top.equalTo(dashedLineView.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-13)
        }

        memberCntLabel.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(borderView)
        }

        memberTableView.snp.makeConstraints {
            $0.top.equalTo(memberCntLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(borderView)
            $0.height.equalTo(50 * (UIScreen.main.bounds.height / 812))
            $0.bottom.equalToSuperview()
        }
    }

    override func setupBinding() {
        exitButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        moreButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let lightID = self?.lightId else { return }
                guard let viewmodel = self?.submittedViewModel else { return }
                self?.navigationController?.pushViewController(
                    SubmittedDetailThunViewController(
                        lightID: lightID,
                        superViewModel: viewmodel),
                    animated: true)
            })
            .disposed(by: disposeBag)
    
        
        viewModel.getDetailThunList(lightId: lightId ?? -1) { response in
            let nameResponse = response[0].organizer
            self.setupData(
                response[0].title,
                response[0].date ?? "날짜미정",
                response[0].time ?? "시간미정",
                response[0].place ?? "장소미정",
                response[0].category,
                nameResponse[0].name,
                response[0].peopleCnt ?? 0,
                response[0].lightMemberCnt)
        }
        
        viewModel.getMemberList(lightId: lightId ?? -1) { member in
            Observable.of(member)
                .bind(to: self.memberTableView.rx.items) { _, row, item -> UITableViewCell in
                    guard let cell = self.memberTableView.dequeueReusableCell(
                        withIdentifier: "DetailThunMemberTableViewCell",
                        for: IndexPath(row: row, section: 0)
                    ) as? DetailThunMemberTableViewCell else { return UITableViewCell() }
                    
                    if let profileImage = item.profileImage {
                        cell.setupData(item.name, profileImage)
                    }
                    self.memberTableView.snp.updateConstraints {
                        $0.height.equalTo(self.memberTableView.contentSize.height)
                    }
                    if let profileImage = item.profileImage {
                        cell.setupData(item.name, profileImage)
                    } else {
                        cell.setupNameData(item.name)
                    }

                    return cell
                }
                .disposed(by: self.disposeBag)
        }
        
        memberTableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
//                self?.navigationController?.pushViewController(CheckMemberInfoViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CompleteThunViewController {
    func setupData(
        _ title: String,
        _ date: String,
        _ time: String,
        _ place: String,
        _ category: String,
        _ name: String,
        _ peopleCnt: Int,
        _ lightMemberCnt: Int
    ){
        let dateStr = date.replacingOccurrences(of: "-", with: ".")
        titleLabel.text = title
        dateLabel.text = "날짜  \(dateStr)"
        dateLabel.changeFontColor(targetString: "날짜", color: .ptGray01)
        timeLabel.text = "시간  \(time)"
        timeLabel.changeFontColor(targetString: "시간", color: .ptGray01)
        placeLabel.text = "장소  \(place)"
        placeLabel.changeFontColor(targetString: "장소", color: .ptGray01)
        categoryLabel.text = "카테고리  \(category)"
        categoryLabel.changeFontColor(targetString: "카테고리", color: .ptGray01)
        organizerNameLabel.text = "개설자  \(name)"
        organizerNameLabel.changeFontColor(targetString: "개설자", color: .ptGray01)
        memberCntLabel.text = "번개 참여자 (\(lightMemberCnt)/\(peopleCnt))"
    }
}

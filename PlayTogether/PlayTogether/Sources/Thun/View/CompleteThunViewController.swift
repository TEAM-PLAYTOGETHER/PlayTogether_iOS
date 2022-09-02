import UIKit
import RxSwift

// MARK: tableView rx로 바꿀 때, memberTableView의 높이 값도 변경해줘야함
// MARK: SubmittedDetailThunViewController의 memberTableView setupBinding()부분을 참고해서 바꾸면 됌
class CompleteThunViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()

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
        $0.text = "번개 오픈을\n완료했어요!"
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
        $0.text = "우리집에서 피자 먹기"
    }

    private let dateLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
        $0.text = "날짜  2022.04.15"
        $0.changeFontColor(targetString: "날짜", color: .ptGray01)
    }

    private let timeLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
        $0.text = "시간  18:00 ~"
        $0.changeFontColor(targetString: "시간", color: .ptGray01)
        
    }

    private let placeLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
        $0.text = "장소  우리집"
        $0.changeFontColor(targetString: "장소", color: .ptGray01)
    }

    private let categoryLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
        $0.text = "카테고리  음식"
        $0.changeFontColor(targetString: "카테고리", color: .ptGray01)
    }

    private let organizerNameLabel = UILabel().then {
        $0.font = .pretendardMedium(size: 14)
        $0.textColor = .ptBlack01
        $0.text = "개설자  문수제비"
        $0.changeFontColor(targetString: "개설자", color: .ptGray01)
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
        $0.text = "번개 참여자 (2/6)"
    }

    private lazy var memberTableView = UITableView().then {
        $0.register(DetailThunMemberTableViewCell.self, forCellReuseIdentifier: DetailThunMemberTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = (UIScreen.main.bounds.height / 812) * 60
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
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
            $0.height.equalTo(500)
            $0.bottom.equalToSuperview()
        }
    }

    override func setupBinding() {
        exitButton.rx.tap
            .bind { [weak self] in
                print("나가기 버튼")
            }
            .disposed(by: disposeBag)
        
        moreButton.rx.tap
            .bind { [weak self] in
                print("자세히보기 버튼")
            }
            .disposed(by: disposeBag)
    }
}

extension CompleteThunViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailThunMemberTableViewCell", for: indexPath) as! DetailThunMemberTableViewCell
        return cell
    }
}


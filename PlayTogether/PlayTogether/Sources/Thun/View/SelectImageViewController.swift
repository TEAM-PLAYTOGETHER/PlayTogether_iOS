import UIKit
import RxSwift

class SelectImageViewController: BaseViewController {
    private lazy var disposeBag = DisposeBag()
    private let viewModel = SubmittedDetailThunViewModel()
    var lightId : Int?
    var indexPath: Int?
    var imageCount: Int?
    
    init(lightID: Int, indexPath: Int, imageCount: Int) {
        self.lightId = lightID
        self.indexPath = indexPath
        self.imageCount = imageCount
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let exitButton = UIButton().then {
        $0.setImage(.ptImage(.clearIcon), for: .normal)
    }

    private let pageLabel = UILabel().then {
        $0.font = .pretendardRegular(size: 18)
        $0.textColor = .white
    }

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    override func setupViews() {
        view.backgroundColor = .ptBlack01

        view.addSubview(exitButton)
        view.addSubview(pageLabel)
        view.addSubview(imageView)
    }

    override func setupLayouts() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(29)
            $0.leading.equalToSuperview().offset(20)
        }

        pageLabel.snp.makeConstraints {
            $0.centerY.equalTo(exitButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(pageLabel.snp.bottom).offset(10)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }

    override func setupBinding() {
        exitButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.getImageList(lightId: lightId ?? -1) { image in
            if let imageView = image[self.indexPath ?? -1] {
                self.imageView.loadImage(url: imageView)
            }
            self.pageLabel.text = "\((self.indexPath ?? 0) + 1)/\(self.imageCount ?? 0)"
        }
    }
}

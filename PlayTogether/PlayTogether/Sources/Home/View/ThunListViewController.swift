//
//  ThunListViewController.swift
//  PlayTogether
//
//  Created by 김수정 on 2022/08/11.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ThunListViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    init(currentPageIndex: Int, index: Int) {
        super.init()
        self.currentPage = currentPageIndex
        self.eatGoDoLabel.text = nameArray[index]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backButton = UIButton().then {
        $0.setImage(.ptImage(.backIcon), for: .normal)
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(.ptImage(.searchIcon), for: .normal)
    }
    
    private let beforeButton = UIButton().then {
        $0.setImage(.ptImage(.beforeIcon), for: .normal)
    }
    
    var nameArray = ["먹을래","갈래","할래"]
    
    var currentPage = Int() {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            pageViewController.setViewControllers(
                [dataViewControllers[currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    var eatGoDoLabel = UILabel().then {
        $0.font = .pretendardBold(size: 18)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let afterButton = UIButton().then {
        $0.setImage(.ptImage(.afterIcon), for: .normal)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [beforeButton,eatGoDoLabel,afterButton]).then {
        $0.spacing = 20
    }
    
    private let eatThunListViewController = EatThunListViewController()
    private let goThunListViewController = GoThunListViewController()
    private let doThunListViewController = DoThunListViewController()
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
        $0.setViewControllers([dataViewControllers[currentPage]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var dataViewControllers: [UIViewController] {
        [eatThunListViewController, goThunListViewController, doThunListViewController]
    }
    
    override func setupViews() {
        setupSuperView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        navigationItem.titleView = stackView
        view.addSubview(pageViewController.view)
    }
    
    private func setupSuperView() {
        eatThunListViewController.setupSuperView(superView: self)
    }
    
    override func setupLayouts() {
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        beforeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let nextIndex = max(self.currentPage - 1, 0)
                self.currentPage = nextIndex
                self.nameArray[self.currentPage] = self.nameArray[nextIndex]
                self.eatGoDoLabel.text = self.nameArray[nextIndex]
            })
            .disposed(by: disposeBag)
        
        afterButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let nextIndex = min(self.currentPage + 1, self.nameArray.count - 1)
                self.currentPage = nextIndex
                self.eatGoDoLabel.text = self.nameArray[nextIndex]
            })
            .disposed(by: disposeBag)
    }
}

extension ThunListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0 else { return nil }
        return dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
                  index + 1 < dataViewControllers.count else { return nil }
        return dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0], let index = dataViewControllers.firstIndex(of: viewController) else { return }
        currentPage = index
        eatGoDoLabel.text = nameArray[index]
    }
}

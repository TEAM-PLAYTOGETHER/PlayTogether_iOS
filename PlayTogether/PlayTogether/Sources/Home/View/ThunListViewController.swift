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

class ThunListViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let beforeButton = UIButton().then {
        $0.setImage(.ptImage(.beforeIcon), for: .normal)
    }
    
    var nameArray = ["먹을래","갈래","할래"]
    
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
    
    private let thunButton = UIButton().then {
        $0.setImage(.ptImage(.floatingIcon), for: .normal)
    }
    
    private let eatThunListViewController = EatThunListViewController()
    private let goThunListViewController = GoThunListViewController()
    private let doThunListViewController = DoThunListViewController()
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
        $0.setViewControllers([dataViewControllers[1]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var dataViewControllers: [UIViewController] {
        [eatThunListViewController, goThunListViewController, doThunListViewController]
    }
    
    var currentPage = 1 {
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
    
    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func searchButtonDidTap() {
        print("searchBtn")
    }
    
    private func configureNaigationvBar() {
        let navigationBarController = navigationController?.navigationBar
        navigationBarController?.isTranslucent = false
        navigationBarController?.tintColor = .white
        navigationItem.titleView = stackView
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .plain, target: self, action: #selector(backButtonDidTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(searchButtonDidTap))
    }
    
    private func beforeButtonDidTap() {
        let nextIndex = max(currentPage - 1, 0)
        currentPage = nextIndex
        nameArray[currentPage] = nameArray[nextIndex]
        eatGoDoLabel.text = nameArray[nextIndex]
    }
    
    private func afterButtonDidTap() {
        let nextIndex = min(currentPage + 1, nameArray.count - 1)
        currentPage = nextIndex
        eatGoDoLabel.text = nameArray[nextIndex]
    }
    
    override func setupViews() {
        configureNaigationvBar()
        view.addSubview(pageViewController.view)
        view.addSubview(thunButton)
    }
    
    override func setupLayouts() {
        
        thunButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(36)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBinding() {
        beforeButton.rx.tap
            .bind { [weak self] in
                self?.beforeButtonDidTap()
            }
            .disposed(by: disposeBag)
        
        afterButton.rx.tap
            .bind { [weak self] in
                self?.afterButtonDidTap()
            }
            .disposed(by: disposeBag)
    }
}

extension ThunListViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0 else { return nil }
        return dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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

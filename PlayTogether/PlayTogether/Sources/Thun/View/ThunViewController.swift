//
//  ThunViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import UIKit
import SnapKit
import Then

final class ThunViewController: BaseViewController {
    
    private let submittedThunViewController = SubmittedThunViewController()
    private let openedThunViewController = OpenedThunViewController()
    private let likedThunViewController = LikedThunViewController()
    
    private let segmentedControl = UnderlineSegmentedControl(items: ["신청한", "오픈한", "찜한"]).then {
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,.font: UIFont.pretendardBold(size: 14)], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.ptGreen,.font: UIFont.pretendardBold(size: 14)],for: .selected)
        $0.addTarget(SubmittedThunViewController(), action: #selector(changeValue(control:)), for: .valueChanged)
        $0.selectedSegmentIndex = 0
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
        $0.setViewControllers([dataViewControllers[0]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
    }
    
    var dataViewControllers: [UIViewController] {
        [submittedThunViewController, openedThunViewController, likedThunViewController]
    }
    
    var currentPage = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            pageViewController.setViewControllers(
                [dataViewControllers[currentPage]], direction: direction, animated: true, completion: nil
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNaigationvBar()
    }
    
    override func setupViews() {
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)
    }
    
    override func setupLayouts() {
        view.backgroundColor = .white
        
        segmentedControl.snp.makeConstraints {
            let height = (view.frame.height / 812) * 50
            $0.top.equalToSuperview()
            $0.size.equalTo(CGSize(width: view.frame.width, height: height))
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBinding() {}
    
    private func configureNaigationvBar() {
        let navigationBarController = navigationController?.navigationBar
        navigationBarController?.isTranslucent = false
        navigationBarController?.tintColor = .white
        navigationItem.title = "나의 번개"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backIcon"), style: .plain, target: self, action: #selector(backButtonDidTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "searchIcon"), style: .plain, target: self, action: #selector(searchButtonDidTap))
    }
    
    @objc func changeValue(control: UnderlineSegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
    
    @objc func backButtonDidTap() {
        print("backBtn")
    }
    
    @objc func searchButtonDidTap() {
        print("searchBtn")
    }
}

extension ThunViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
        segmentedControl.selectedSegmentIndex = index
    }
}

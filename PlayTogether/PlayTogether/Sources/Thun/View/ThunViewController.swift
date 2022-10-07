//
//  ThunViewController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/19.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class ThunViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = ThunViewModel()
    private let submittedThunViewController = SubmittedThunViewController()
    private let openedThunViewController = OpenedThunViewController()
    private let likedThunViewController = LikedThunViewController()
    
    private let segmentedControl = UnderlineSegmentedControl(items: ["신청한", "오픈한", "찜한"]).then {
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             .font: UIFont.pretendardBold(size: 14)],for: .normal)
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.ptGreen,
             .font: UIFont.pretendardBold(size: 14)],for: .selected)
        $0.selectedSegmentIndex = 0
    }
    
    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    ).then {
        $0.setViewControllers([dataViewControllers[0]], direction: .forward, animated: true)
        $0.delegate = self
        $0.dataSource = self
    }
    
    private var dataViewControllers: [UIViewController] {
        [submittedThunViewController, openedThunViewController, likedThunViewController]
    }
    
    var currentPage = 0 {
        didSet {
            let direction:UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            pageViewController.setViewControllers(
                [dataViewControllers[currentPage]], direction: direction, animated: true, completion: nil
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        configureNaigationvBar()
    }
    
    override func setupViews() {
        setupViewModel()
        setupSuperView()
        segmentedControl.addTarget(
            self,action: #selector(segmentedButtonDidTap(control:)), for: .valueChanged)
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
    
    private func setupViewModel() {
        submittedThunViewController.setupViewModel(viewModel: viewModel)
        openedThunViewController.setupViewModel(viewModel: viewModel)
        likedThunViewController.setupViewModel(viewModel: viewModel)
    }
    
    private func setupSuperView() {
        submittedThunViewController.setupSuperView(superView: self)
        openedThunViewController.setupSuperView(superView: self)
        likedThunViewController.setupSuperView(superView: self)
    }
    
    private func configureNaigationvBar() {
        let navigationBarController = navigationController?.navigationBar
        navigationBarController?.isTranslucent = false
        navigationBarController?.tintColor = .white
        navigationItem.title = "나의 번개"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "searchIcon"),
            style: .plain,
            target: self,
            action: #selector(searchButtonDidTap))
    }
    
    @objc func segmentedButtonDidTap(control: UnderlineSegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
    
    @objc func searchButtonDidTap() {
        print("searchBtn")
    }
}

extension ThunViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        return dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
              index + 1 < dataViewControllers.count
        else { return nil }
        return dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ){
        guard let viewController = pageViewController.viewControllers?[0],
              let index = dataViewControllers.firstIndex(of: viewController)
        else { return }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}

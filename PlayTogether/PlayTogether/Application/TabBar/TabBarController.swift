//
//  TabBarController.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/07/14.
//

import UIKit
import Then

final class TabBarController: UITabBarController {
    private let homeViewController = HomeViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "홈",
            image: .ptImage(.homeInactive).withRenderingMode(.alwaysOriginal),
            selectedImage: .ptImage(.homeActive).withRenderingMode(.alwaysOriginal))
    }
    private let thunViewController = ThunViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "번개",
            image: .ptImage(.thunInactive).withRenderingMode(.alwaysOriginal),
            selectedImage: .ptImage(.thunActive).withRenderingMode(.alwaysOriginal))
    }
    private let chatViewController = ChattingListViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "채팅",
            image: .ptImage(.chatInactive).withRenderingMode(.alwaysOriginal),
            selectedImage: .ptImage(.chatActive).withRenderingMode(.alwaysOriginal))
    }
    private let mypageViewController = MyPageViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: .ptImage(.mypageInactive).withRenderingMode(.alwaysOriginal),
            selectedImage: .ptImage(.mypageActive).withRenderingMode(.alwaysOriginal))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
}

private extension TabBarController {
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.layer.applyShadow()
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.pretendardMedium(size: 10),
                NSAttributedString.Key.foregroundColor: UIColor.ptGray02
            ],
            for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.pretendardMedium(size: 10),
                NSAttributedString.Key.foregroundColor: UIColor.ptBlack01
            ],
            for: .selected
        )
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let thunNavigationController = UINavigationController(rootViewController: thunViewController)
        let chatNavigationController = UINavigationController(rootViewController: chatViewController)
        let mypageNavigationController = UINavigationController(rootViewController: mypageViewController)
        
        setViewControllers([
            homeNavigationController,
            thunNavigationController,
            chatNavigationController,
            mypageNavigationController
        ], animated: false)
    }
}

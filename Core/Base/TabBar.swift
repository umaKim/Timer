//
//  TabBar.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    private let uid: String
    
    init(with uid: String) {
        self.uid = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: TimerViewController(TimerView(), TimerViewModel()),
                                title: "timer",
                                imageName: "timer"),
            
            createNavController(viewController: SettingViewController(SettingView(), SettingViewModel()),
                                title: "Setting",
                                imageName: "person")
        ]
        
        tabBar.tintColor = .label
    }
    
    fileprivate func createNavController(
        viewController: UIViewController,
        title: String,
        imageName: String
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = .init(systemName: imageName)
        return navController
    }
}

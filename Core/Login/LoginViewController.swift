//
//  LoginViewController.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import CombineCocoa
import Combine
import UIKit

class LoginViewController: BaseViewController<LoginView, LoginViewModel> {
    
    private func changeRootViewcontroller(with uid: String) {
        scDelegate?.changeRootViewController(MainTabBarViewController(with: uid))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .gmail:
                    self.viewModel.logIn(self)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] noti in
                switch noti {
                case .getUid(let uid):
                    self.changeRootViewcontroller(with: uid)
                }
            }
            .store(in: &cancellables)
    }
}

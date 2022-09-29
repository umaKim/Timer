//
//  SettingViewController.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import Combine
import UIKit

class SettingViewController: BaseViewController<SettingView, SettingViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [contentView.logoutButton]
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .logout:
                    self.viewModel.googleSignOut()
                    scDelegate?.changeRootViewController(LoginViewController(LoginView(), LoginViewModel()))
                }
            }
            .store(in: &cancellables)
    }
}

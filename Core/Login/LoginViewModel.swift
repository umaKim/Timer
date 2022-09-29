//
//  LoginViewModel.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import Firebase
import GoogleSignIn
import Combine

enum LoginViewModelNotification {
    case getUid(String)
}

class LoginViewModel: BaseViewModel<LoginViewModelNotification> {
    
    private let networkService: SocialAuthorizable
    
    init(_ networkService: SocialAuthorizable = NetworkService()) {
        self.networkService = networkService
    }
    
    func logIn(_ viewController: UIViewController) {
        networkService.signIn(with: viewController) {[unowned self] uid in
            self.sendNotification(.getUid(uid))
        }
    }
}

//
//  SettingViewModel.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//
import GoogleSignIn
import Foundation

enum SettingViewModelNotification {
    
}

class SettingViewModel: BaseViewModel<SettingViewModelNotification> {
    
    private let networkService: SocialAuthorizable
    
    init(_ networkService: SocialAuthorizable = NetworkService()) {
        self.networkService = networkService
    }
    
    func googleSignOut() {
        networkService.signOut()
    }
}

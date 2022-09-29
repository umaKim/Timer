//
//  SettingView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//
import FirebaseAuth
import GoogleSignIn
import CombineCocoa
import Combine
import UIKit

enum SettingViewAction {
    case logout
}

class SettingView: BaseView<SettingViewAction> {
    
    private(set) lazy var logoutButton = UIBarButtonItem(title: "logout", style: .done, target: nil, action: nil)
    
    private let emailLabel: UILabel = {
       let lb = UILabel()
        lb.text = "Eazel user"
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var segmentContronl: UISegmentedControl = {
        let sc: UISegmentedControl = UISegmentedControl(items: ["Light", "Dark"])
        sc.backgroundColor = UIColor.gray
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    private func bind() {
        logoutButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.sendAction(.logout)
            }
            .store(in: &cancellables)
        
        segmentContronl
            .selectedSegmentIndexPublisher
            .sink { index in
                switch index {
                case 0:
                    scDelegate?.changeMode(.light)
                case 1:
                    scDelegate?.changeMode(.dark)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        emailLabel.text = Auth.auth().currentUser?.email ?? "Eazel user"
        
        let sv = UIStackView(arrangedSubviews: [emailLabel, segmentContronl])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 30
        
        addSubviews(sv)
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

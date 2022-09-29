//
//  LoginView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import GoogleSignIn
import UIKit

enum LoginViewAction {
    case gmail
}

class LoginView: BaseView<LoginViewAction> {
    
    private lazy var titleLabel: UILabel  = {
       let label = UILabel()
        label.text = "Stop Watch"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var gidButton: UIButton = {
       let bt = UIButton()
        bt.setTitle("Google log in", for: .normal)
        bt.setTitleColor(UIColor.label, for: .normal)
        bt.layer.cornerRadius = 6
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.systemGray.cgColor
        return bt
    }()
    
    
    
    override init() {
        super.init()
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        gidButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.sendAction(.gmail)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, gidButton])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.spacing = 16
        
        addSubviews(sv)
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

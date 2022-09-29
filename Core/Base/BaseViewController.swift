//
//  BaseViewController.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import Combine
import UIKit

class BaseViewController<CV, T>: UIViewController {
    var cancellables: Set<AnyCancellable>
    
    let contentView: CV
    let viewModel: T
    
    init(
        _ cv: CV,
        _ vm: T
    ) {
        self.contentView = cv
        self.viewModel = vm
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView as? UIView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

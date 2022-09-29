//
//  BaseView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import Combine
import UIKit

class BaseView<T>: UIView {
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<T, Never>()
    
    var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
    }
    
    public func sendAction(_ input: T) {
        actionSubject.send(input)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


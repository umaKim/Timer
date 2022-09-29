//
//  BaseViewModel.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import Combine
import UIKit

class BaseViewModel<T> {
    private(set) lazy var notifyPublisher = notifySubject.eraseToAnyPublisher()
    private let notifySubject = PassthroughSubject<T, Never>()
    
    var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
    }
    
    public func sendNotification(_ input: T) {
        notifySubject.send(input)
    }
}

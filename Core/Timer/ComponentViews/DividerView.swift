//
//  DividerView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/08.
//

import UIKit

final class DividerView: UIView {
    init(height: CGFloat = 1) {
        super.init(frame: .zero)
        backgroundColor = .systemGray
        alpha = 0.5
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

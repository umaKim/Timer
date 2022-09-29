//
//  UIView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import UIKit

extension UIView {
    func addSubviews(_ uiViews: UIView...) {
        uiViews.forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
    }
}

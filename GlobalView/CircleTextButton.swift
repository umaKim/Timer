//
//  CircleTextButton.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import UIKit

final class CircleTextButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
    }
    
    convenience init(_ text: String, _ backgroundColor: UIColor) {
        self.init()
        
        self.setText(text)
        self.setColor(backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setText(_ text: String) {
        self.setTitle(text, for: .normal)
    }
    
    public func setColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    private func setupUI() {
        alpha = 0.8
        
        let length: CGFloat = 100
        
        widthAnchor.constraint(equalToConstant: length).isActive = true
        heightAnchor.constraint(equalToConstant: length).isActive = true
        
        layer.masksToBounds = true
        layer.cornerRadius = length / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
}

//
//  TimeLapCollectionViewCell.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/04.
//

import UIKit

class TimeLapCollectionViewCell: UICollectionViewCell {
    static let identifier = "TimeLapCollectionViewCell"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Title"
        return lb
    }()
    
    private lazy var timerLabel: UILabel = {
        let lb = UILabel()
        lb.text = "00.00"
        return lb
    }()
    
    private let bottomDividerView = DividerView()
    
    public func configure(_ model: TimeLap) {
        DispatchQueue.main.async {
            self.titleLabel.text = "랩 \(model.title)"
            self.timerLabel.text = "\(model.minute):\(model.seconds)"
            self.timerLabel.textColor = model.textColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        titleLabel.textColor = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        addSubviews(titleLabel,timerLabel, bottomDividerView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}

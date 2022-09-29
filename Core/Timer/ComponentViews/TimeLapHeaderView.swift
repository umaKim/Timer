//
//  TimeLapHeaderView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/04.
//
import Combine
import UIKit

class TimeLapHeaderView: UICollectionReusableView {
    static let identifier = "TimeLapHeaderView"
    
    private var cancellables: Set<AnyCancellable>
    
    private let topDividerView = DividerView()
    
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
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        isHidden = true
        
        addSubviews(topDividerView, titleLabel,timerLabel, bottomDividerView)
        
        NSLayoutConstraint.activate([
            topDividerView.topAnchor.constraint(equalTo: topAnchor),
            topDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    public func configure(_ model: AnyPublisher<HeaderViewDataStreamAction, Never>) {
        model
            .sink {[unowned self] action in
                switch action {
                case .timer(let lap):
                    self.titleLabel.text = "랩 \(lap.title)"
                    self.timerLabel.text = "\(lap.minute):\(lap.seconds)"
                    
                case .show(let shouldShow):
                    self.isHidden = !shouldShow
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TimerView.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//
import CombineCocoa
import Combine
import UIKit

enum TimerViewAction {
    case left
    case right
}

enum TimerStatus {
    case beforeCounting
    case counting
    case pause
}

//MARK: - Status
// beforeCount
// L: disabledLap  R: start

// counting
// L: abledLap R: Stop

// pause
// L: reset R: start

class TimerView: BaseView<TimerViewAction> {
    
    private lazy var timerLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 70, weight: .light)
        lb.text = "00:00.00"
        lb.textAlignment = .center
        lb.sizeToFit()
        return lb
    }()
    
    private lazy var leftButton = CircleTextButton("랩", .darkGray)
    private lazy var rightButton = CircleTextButton("시작", .systemGreen)
    
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let tv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        tv.register(TimeLapHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: TimeLapHeaderView.identifier)
        tv.register(TimeLapCollectionViewCell.self,
                    forCellWithReuseIdentifier: TimeLapCollectionViewCell.identifier)
         return tv
    }()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    public func updateTime(minute: String, second: String) {
        self.timerLabel.text = "\(minute):\(second)"
    }
    
    public func updateButtons(_ timerStatus: TimerStatus) {
        switch timerStatus {
        case .beforeCounting:
            self.leftButton.setText("랩")
            self.leftButton.setColor(.darkGray)
            self.leftButton.isEnabled = false
            
            self.rightButton.setText("시작")
            self.rightButton.setColor(.systemGreen)
            
        case .counting:
            self.leftButton.setText("랩")
            self.leftButton.setColor(.systemGray)
            self.leftButton.isEnabled = true
            
            self.rightButton.setText("중단")
            self.rightButton.setColor(.systemRed)
            
        case .pause:
            self.leftButton.setText("재설정")
            self.leftButton.setColor(.systemGray)
            
            self.rightButton.setText("시작")
            self.rightButton.setColor(.systemGreen)
        }
    }
    
    private func bind() {
        leftButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.sendAction(.left)
            }
            .store(in: &cancellables)
        
        rightButton
            .tapPublisher
            .sink {[unowned self] _ in
                self.sendAction(.right)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        let buttonSv = UIStackView(arrangedSubviews: [leftButton, rightButton])
        buttonSv.axis = .horizontal
        buttonSv.distribution = .equalSpacing
        buttonSv.alignment = .fill
        
        addSubviews(timerLabel, buttonSv, collectionView)
        
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.bounds.height / 4),
            
            buttonSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonSv.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: buttonSv.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



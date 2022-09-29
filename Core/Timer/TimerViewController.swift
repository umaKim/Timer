//
//  TimerViewController.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//

import CombineCocoa
import Combine
import UIKit

let scDelegate = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)

enum HeaderViewDataStreamAction {
    case timer(TimeLap)
    case show(Bool)
}

class TimerViewController: BaseViewController<TimerView, TimerViewModel> {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, TimeLap>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, TimeLap>
    
    private var dataSource: DataSource?
    
    private enum Section: CaseIterable {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.collectionView.delegate = self
        bind()
        configureDataSource()
        updateSections()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[unowned self] action in
                switch action {
                case .left:
                    self.viewModel.leftButton()
                    
                case .right:
                    self.viewModel.rightButton()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] notification in
                switch notification {
                case .updateTimerStatus(let currentStatus):
                    self.contentView.updateButtons(currentStatus)
                    
                case .updateTimer(let minute, let seconds):
                    self.contentView.updateTime(minute: minute, second: seconds)
                    
                case .reload:
                    self.updateSections()
                    
                case .updateLapsTimer(let timeLap):
                    self.dataStream.send(.timer(timeLap))
                    
                case .showCurrentLapsTimer(let isHidden):
                    self.dataStream.send(.show(isHidden))
                }
            }
            .store(in: &cancellables)
    }
    
    private var dataStream = PassthroughSubject<HeaderViewDataStreamAction, Never>()
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: contentView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeLapCollectionViewCell.identifier, for: indexPath) as? TimeLapCollectionViewCell
            else {return UICollectionViewCell()}
            cell.configure(self.viewModel.laps[indexPath.item])
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimeLapHeaderView.identifier, for: indexPath) as? TimeLapHeaderView
            view?.configure(self.dataStream.eraseToAnyPublisher())
            return view
        }
    }
    
    private func updateSections() {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.laps)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension TimerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.bounds.width, height: 50)
    }
}

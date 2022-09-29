//
//  ResumableTimer.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/03.
//
import Combine
import Foundation

class ResumableTimer: NSObject {
    
    private(set) var counterSubject = CurrentValueSubject<CounterValue,Never>(.time(0))
    
    private(set) var timer: Timer = Timer()
    
    private var startTime: Float = 0
    private var elapsedTime: Float = 0
    
    private let isMainThread: Bool
    
    // MARK: Init
    init(
        interval: Double,
        onMainThread: Bool = true
    ) {
        self.interval = interval
        self.isMainThread = onMainThread
    }
    
    // MARK: API
    private var interval: Double = 0.0
    
    func start() {
        runTimer(interval: interval)
    }
    
    func pause() {
        elapsedTime = Float(Date.timeIntervalSinceReferenceDate - Double(startTime))
        timer.invalidate()
    }
    
    func resume() {
        interval -= Double(elapsedTime)
        runTimer(interval: interval)
    }
    
    func invalidate() {
        timer.invalidate()
    }
    
    func reset() {
        startTime = 0
    }
    
    // MARK: Private
    private func runTimer(interval: Double) {
        timer = Timer.scheduledTimer(timeInterval: 0.035,
                                     target: self,
                                     selector: #selector(updateMainTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        if isMainThread {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    @objc
    private func updateMainTimer() {
        startTime += 0.035
        counterSubject.send(.time(startTime))
    }
}

enum CounterValue {
    case time(Float)
}

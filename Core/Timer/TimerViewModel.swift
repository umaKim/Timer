//
//  TimerViewModel.swift
//  Timer
//
//  Created by 김윤석 on 2022/08/01.
//
import Combine
import CombineCocoa
import Foundation
import UIKit

enum TimerViewModelNotification {
    case updateTimerStatus(TimerStatus)
    case updateTimer(String, String)
    case updateLapsTimer(TimeLap)
    case showCurrentLapsTimer(Bool)
    case reload
}

class TimerViewModel: BaseViewModel<TimerViewModelNotification> {
    
    private var resumeableWatch: ResumableTimer?
    private var lapsWatch: ResumableTimer?
    
    private var timerSeconds: Float = 0
    private var lapsMinute: String = ""
    private var lapsSeconds: String = ""
     
    private var timerStatus: TimerStatus
    
    private var currentLaps: TimeLap?
    private(set) var laps: [TimeLap] = []
    
    private let networkService: Networkable
    
    init(
        networkService: Networkable = NetworkService()
    ) {
        self.networkService = networkService
        self.timerStatus = .beforeCounting
        super.init()
        
        resumeableWatch  = ResumableTimer(interval: 0.035)
        lapsWatch        = ResumableTimer(interval: 0.035)
        
        bind()
        fetchData()
    }
    
    private func saveData(_ lap: TimeLap) {
        networkService.saveData(lap)
    }
    
    private func fetchData() {
        networkService.fetchData(completion: {[unowned self] result in
            switch result {
            case .success(let timeLaps):
                self.laps.append(contentsOf: timeLaps)
                self.laps.sort(by: {$0.title > $1.title})
                self.setLapsColors()
                self.sendNotification(.reload)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func bind() {
        resumeableWatch?
            .counterSubject
            .sink(receiveValue: {[unowned self] value in
                switch value {
                case .time(let time):
                    let timer = self.convertTimeIntoFormatTime(time)
                    self.sendNotification(.updateTimer(timer.0, timer.1))
                }
            })
            .store(in: &cancellables)
        
        lapsWatch?
            .counterSubject
            .sink(receiveValue: {[unowned self] value in
                switch value {
                case .time(let time):
                    self.timerSeconds = time
                    let timer = self.convertTimeIntoFormatTime(time)
                    self.lapsMinute  = timer.0
                    self.lapsSeconds = timer.1
                    self.currentLaps = .init(title: self.laps.count + 1,
                                             timerSeconds: time,
                                             minute: lapsMinute,
                                             seconds: lapsSeconds,
                                             textColor: .label)
                    guard
                        let currentLaps = currentLaps
                    else { return }
                    self.sendNotification(.updateLapsTimer(currentLaps))
                }
            })
            .store(in: &cancellables)
    }
    
    private func convertTimeIntoFormatTime(_ startTime: Float) -> (String, String) {
        var seconds: String = String(format: "%.2f", (startTime.truncatingRemainder(dividingBy: 60)))
        if startTime.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        var minutes: String = "\((Int)(startTime / 60))"
        if (Int)(startTime / 60) < 10 {
            minutes = "0\((Int)(startTime / 60))"
        }
        return (minutes, seconds)
    }
    
    private func startTimer(_ timer: ResumableTimer?) {
        timer?.start()
    }
    
    private func resetTimer(_ timer: ResumableTimer?) {
        timer?.reset()
    }
    
    private func pauseTimer(_ timer: ResumableTimer?) {
        timer?.pause()
    }
    
    private func resumeTimer(_ timer: ResumableTimer?) {
        timer?.resume()
    }
    
    private func appendFront(with lap: TimeLap) {
//        let tempLaps = self.laps
//        self.laps.removeAll()
//        self.laps.append(lap)
//        self.laps.append(contentsOf: tempLaps)
        self.laps.insert(lap, at: 0)
    }
    
    private func setLapsColors() {
        self.laps = laps
            .filter({$0.title != self.laps.count + 1})
            .map({TimeLap(title: $0.title,
                                     timerSeconds: $0.timerSeconds,
                                     minute: $0.minute,
                                     seconds: $0.seconds,
                                     textColor: .label)})
        guard
            var max = laps
            .max(by: {$0.timerSeconds < $1.timerSeconds}),
            let maxIndex = laps.firstIndex(of: max)
        else {return}

        guard
            var min = laps
            .max(by: {$0.timerSeconds > $1.timerSeconds}),
            let minIndex = laps.firstIndex(of: min)
        else {return }

        max.textColor = .systemRed
        min.textColor = .systemGreen

        laps[maxIndex] = max
        laps[minIndex] = min
    }
    
    //MARK: - Public
    public func leftButton() {
        switch timerStatus {
        case .beforeCounting:
            print("disabled lap - nothing happens")
            
        case .counting:
            print("save lap timer")
            guard
                let currentLaps = currentLaps
            else { return }
            self.appendFront(with: currentLaps)
            self.saveData(currentLaps)
            self.setLapsColors()
            self.resetTimer(lapsWatch)
            self.sendNotification(.reload)
            
        case .pause:
            print("reset timer")
            self.resetTimer(resumeableWatch)
            self.resetTimer(lapsWatch)
           
            self.timerStatus = .beforeCounting
            self.laps.removeAll()
            self.sendNotification(.updateTimer("00", "00.00"))
            self.sendNotification(.reload)
            self.sendNotification(.showCurrentLapsTimer(false))
        }
        
        self.sendNotification(.updateTimerStatus(timerStatus))
    }
    
    public func rightButton() {
        switch timerStatus {
        case .beforeCounting:
            print("start Counting")
            self.startTimer(resumeableWatch)
            self.startTimer(lapsWatch)
            self.timerStatus = .counting
            self.sendNotification(.showCurrentLapsTimer(true))
            
        case .counting:
            print("pause timer")
            self.pauseTimer(resumeableWatch)
            self.pauseTimer(lapsWatch)
            self.timerStatus = .pause
            
        case .pause:
            print("start - continue(resume) counting")
            self.resumeTimer(resumeableWatch)
            self.resumeTimer(lapsWatch)
            self.timerStatus = .counting
        }
        
        sendNotification(.updateTimerStatus(timerStatus))
    }
}

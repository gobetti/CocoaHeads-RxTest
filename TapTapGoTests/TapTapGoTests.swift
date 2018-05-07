//
//  TapTapGoTests.swift
//  TapTapGoTests
//
//  Created by Marcelo Gobetti on 5/6/18.
//

import RxSwift
import XCTest
@testable import TapTapGo

class TapTapGoTests: XCTestCase {
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    func testTapIncrementsScore() {
        let tapsCount = 2
        let tapSource = PublishSubject<()>()
        let viewModel = ViewModel(tapSource: tapSource)
        
        let scoreExpectation = expectation(description: "score = 2")
        
        viewModel.score.subscribe {
            switch $0 {
            case .next(let score):
                if score == tapsCount {
                    scoreExpectation.fulfill()
                } else if score > tapsCount {
                    XCTFail()
                }
            case .error(_):
                XCTFail()
            case .completed:
                XCTFail()
            }
        }.disposed(by: disposeBag)
        
        for _ in 1...tapsCount {
            tapSource.onNext(())
        }
        
        wait(for: [scoreExpectation], timeout: 1.0)
    }
    
    func testTapStartsTimer() {
        let tapSource = PublishSubject<()>()
        let viewModel = ViewModel(tapSource: tapSource)
        
        let noTimerBeforeTapExpectation = expectation(description: "no timer events before tap")
        noTimerBeforeTapExpectation.isInverted = true
        
        viewModel.timer
            .takeUntil(tapSource)
            .subscribe {
                switch $0 {
                case .next(_):
                    noTimerBeforeTapExpectation.fulfill()
                case .error(_):
                    XCTFail()
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        
        let timerStartsOnTapExpectation = expectation(description: "timer emits 4.0 less than 1.5 second after tap")
        
        viewModel.timer
            .subscribe {
                switch $0 {
                case .next(let time):
                    if time == 4.0 {
                        timerStartsOnTapExpectation.fulfill()
                    }
                case .error(_):
                    XCTFail()
                case .completed:
                    XCTFail()
                }
            }.disposed(by: disposeBag)
        
        tapSource.onNext(())
        
        wait(for: [noTimerBeforeTapExpectation,
                   timerStartsOnTapExpectation], timeout: 1.5)
    }
    
    func testTapDoesNotIncrementScoreAfterTimerEnd() {
        let tapSource = PublishSubject<()>()
        let viewModel = ViewModel(tapSource: tapSource)
        
        let noIncrementExpectation = expectation(description: "score should remain 1 after timer end")
        noIncrementExpectation.isInverted = true
        
        viewModel.score
            .subscribe {
                switch $0 {
                case .next(let score):
                    if score > 1 {
                        noIncrementExpectation.fulfill()
                    }
                case .error(_):
                    XCTFail()
                case .completed:
                    break
                }
            }.disposed(by: disposeBag)
        
        tapSource.onNext(())
        
        Observable<Int>.timer(5.1, period: nil, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                tapSource.onNext(())
            }).disposed(by: disposeBag)
        
        wait(for: [noIncrementExpectation], timeout: 6.0)
    }
}

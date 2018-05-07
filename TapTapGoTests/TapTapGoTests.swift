//
//  TapTapGoTests.swift
//  TapTapGoTests
//
//  Created by Marcelo Gobetti on 5/6/18.
//

import RxSwift
import RxTest
import XCTest
@testable import TapTapGo

class TapTapGoTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testTapIncrementsScore() {
        // Input
        let tapSource = scheduler.createHotObservable([
            Recorded.next(5, ()),
            Recorded.next(6, ())
            ])
        
        // SUT
        let viewModel = ViewModel(tapSource: tapSource.asObservable())
        
        // Output
        let results = scheduler.createObserver(Int.self)
        scheduler.scheduleAt(0) {
            viewModel.score.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()
        
        // Compare
        let expected = [
            Recorded.next(5, 1),
            Recorded.next(6, 2)
        ]
        XCTAssertEqual(results.events, expected)
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

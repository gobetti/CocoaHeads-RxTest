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
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
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
        // Input
        let tapSource = scheduler.createHotObservable([
            Recorded.next(5, ())
            ])
        
        // SUT
        let viewModel = ViewModel(tapSource: tapSource.asObservable(),
                                  period: 1.0,
                                  scheduler: scheduler)
        
        // Output
        let results = scheduler.createObserver(RxTimeInterval.self)
        scheduler.scheduleAt(0) {
            viewModel.timer.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()
        
        // Compare
        let expected = [
            Recorded.next(5, 5.0),
            Recorded.next(6, 4.0)
        ]
        XCTAssertEqual(Array(results.events.prefix(2)), expected)
    }
    
    func testTapDoesNotIncrementScoreAfterTimerEnd() {
        // Input
        let tapSource = scheduler.createHotObservable([
            Recorded.next(5, ()),
            Recorded.next(11, ())
            ])
        
        // SUT
        let viewModel = ViewModel(tapSource: tapSource.asObservable(),
                                  period: 1.0,
                                  scheduler: scheduler)
        
        // Output
        let results = scheduler.createObserver(Int.self)
        scheduler.scheduleAt(0) {
            viewModel.score.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()
        
        // Compare
        let expected = [
            Recorded.next(5, 1),
            Recorded.completed(10)
        ]
        XCTAssertEqual(results.events, expected)
    }
}

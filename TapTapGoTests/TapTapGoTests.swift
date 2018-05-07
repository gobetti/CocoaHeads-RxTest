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
}

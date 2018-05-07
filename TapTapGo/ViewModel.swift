//
//  ViewModel.swift
//  TapTapGo
//
//  Created by Marcelo Gobetti on 5/6/18.
//

import RxSwift

struct ViewModel {
    private static let duration: RxTimeInterval = 5.0
    private static let period: RxTimeInterval = 0.1
    
    let score: Observable<Int>
    let timer: Observable<RxTimeInterval>
    
    init(tapSource: Observable<()>) {
        score = tapSource
            .enumerated()
            .map { index, _ in index + 1 }
        
        timer = tapSource
            .take(1)
            .flatMap { _ in
                Observable<Int>.timer(0,
                                      period: ViewModel.period,
                                      scheduler: MainScheduler.instance)
            }.map { RxTimeInterval($0) * ViewModel.period }
            .map { ViewModel.duration - $0 }
            .takeWhile { $0 >= 0 }
    }
}

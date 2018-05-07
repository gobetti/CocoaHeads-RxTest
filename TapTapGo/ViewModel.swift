//
//  ViewModel.swift
//  TapTapGo
//
//  Created by Marcelo Gobetti on 5/6/18.
//

import RxSwift

struct ViewModel {
    let score: Observable<Int>
    
    init(tapSource: Observable<()>) {
        score = tapSource
            .enumerated()
            .map { index, _ in index + 1 }
    }
}

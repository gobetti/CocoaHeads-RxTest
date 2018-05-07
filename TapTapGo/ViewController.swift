//
//  ViewController.swift
//  TapTapGo
//
//  Created by Marcelo Gobetti on 5/6/18.
//

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ViewModel(tapSource: self.tapButton.rx.tap.map { _ in })
    
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.score.map { "\($0)" }
            .bind(to: scoreLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


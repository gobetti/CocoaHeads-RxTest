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
    
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapButton.rx.tap
            .enumerated()
            .map { index, _ in "\(index + 1)" }
            .bind(to: scoreLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


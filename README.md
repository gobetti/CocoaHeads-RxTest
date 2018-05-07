# RxTest vs. XCTestExpectation
## CocoaHeads Florianópolis
In order to compare `RxTest` to `XCTestExpectation`, an extremely simple game was built using RxSwift and each commit tells a story of its evolution.

The game has the following requirements:

1. Every tap should increment 1 in the score
2. The first tap also starts the timer, which should countdown until its end
3. The score can only be incremented while the timer is running
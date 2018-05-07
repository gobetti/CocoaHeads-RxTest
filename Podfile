platform :ios, '11.0'

use_frameworks!

def shared_pods
    pod 'RxCocoa',                  '~> 4.0'
end

target 'TapTapGo' do
    shared_pods
end

target 'TapTapGoTests' do
    shared_pods
    pod 'RxTest' # follows RxCocoa's version
end

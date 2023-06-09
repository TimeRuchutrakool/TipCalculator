//
//  ViewController.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billingInputView = BillingInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            
            logoView,
            resultView,
            billingInputView,
            tipInputView,
            splitInputView,
            UIView()
            
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    
    private let vm = CalculatorVM()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ThemeColor.bg
        layout()
        bind()
        observe()
    }
    
    private func observe(){
        viewTapPublisher.sink { _ in
            self.view.endEditing(true)
        }.store(in: &cancellable)
        
        logoViewTapPublisher.sink { _ in
            
        }.store(in: &cancellable)
    }
    
    private lazy var viewTapPublisher: AnyPublisher<Void,Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void,Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private func bind(){
        
        let input = CalculatorVM.Input(
            billPublisher: billingInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapPublisher
        )
        
        let output = vm.transform(input: input)
       
        output.updateViewPublisher.sink { result in
            self.resultView.configure(result: result)
        }.store(in: &cancellable)
        
        output.resetCalculatorPublisher.sink { _ in
            self.billingInputView.reset()
            self.tipInputView.reset()
            self.splitInputView.reset()
            
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0.5, options: .curveEaseInOut){
                self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
            }completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.logoView.transform = .identity // animate back
                }
            }
        }.store(in: &cancellable)
        
       
    }
    
    private func layout(){
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        billingInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+15)
        }
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
}


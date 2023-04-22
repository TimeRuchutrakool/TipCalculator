//
//  TipInputView.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView{
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "Your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher.flatMap ({
            Just(Tip.tenPercent)
        }).assign(to: \.value, on: tipSubject) //pass value every time got tapped
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.tapPublisher.flatMap({ Just(Tip.fifteenPercent) })
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap({Just(Tip.twentyPercent)})
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom Tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8)
        button.tapPublisher.sink { _ in
            self.handleCustomTipButton()
        }.store(in: &cancellable)
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let tipSubject: CurrentValueSubject<Tip,Never> = .init(.none) // allow to store initial data
    var valuePublisher: AnyPublisher<Tip,Never>{
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        
        [headerView,buttonVStackView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
        
        buttonVStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        
    }
    
    private func handleCustomTipButton(){
        let alertController: UIAlertController = {
            
            let controller = UIAlertController(title: "Enter custom tip", message: nil, preferredStyle: .alert)
            controller.addTextField{ textField in
                textField.placeholder = "Enter desired tip"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            let confirmButton = UIAlertAction(title: "Confirm", style: .default){ _ in
                guard let text = controller.textFields?.first?.text, let value = Int(text) else {return}
                self.tipSubject.send(.custom(value: value))
            }
            [cancelButton,confirmButton].forEach(controller.addAction(_:))
            return controller
        }()
        
        parentViewController?.present(alertController, animated: true)
        
    }
    
    private func buildTipButton(tip: Tip) -> UIButton{
        let button = UIButton(type: .custom)
        
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8)
        let text = NSMutableAttributedString(string: tip.stringValue, attributes: [.font:ThemeFont.bold(ofSize: 20),.foregroundColor: UIColor.white])
        text.addAttributes([.font:ThemeFont.demibold(ofSize: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
    private func observe(){
        tipSubject.sink { tip in
            self.resetView()
            switch tip{
            case .none:
                break
            case .tenPercent:
                self.tenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                self.fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                self.twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .custom(value: let value):
                self.customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(string: "$\(value)", attributes: [.font:ThemeFont.bold(ofSize: 20)])
                text.addAttributes([.font:ThemeFont.bold(ofSize: 14)], range: NSMakeRange(0, 1))
                self.customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellable)
    }
    
    private func resetView(){
        [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton,
            customTipButton
        ].forEach({
            $0.backgroundColor = ThemeColor.primary
        })
        
        let text = NSMutableAttributedString(string: "Custom tip", attributes: [.font:ThemeFont.bold(ofSize: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
}




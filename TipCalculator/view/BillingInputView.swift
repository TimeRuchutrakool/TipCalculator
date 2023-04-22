//
//  BillingInputView.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit
import Combine
import CombineCocoa

class BillingInputView: UIView{
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Enter", bottomText: "Your bill")
        return view
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8)
        return view
    }()
    
    private let currencyLabel: UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demibold(ofSize: 28)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),doneButton]
        textField.inputAccessoryView = toolBar
        
        return textField
    }()
    
    init(){
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    //passthrough can accept and emit
    private var billSubject: PassthroughSubject<Double,Never> = .init() //send text in textfield to vm //ObserveObject for other class
    private var cancellable = Set<AnyCancellable>()
    var valuePublisher: AnyPublisher<Double,Never>{ //AnyPublisher can only emit
        return billSubject.eraseToAnyPublisher()
    }
    
    private func observe(){
        textField.textPublisher.sink { text in
            self.billSubject.send(text?.doubleValue ?? 0)
        }.store(in: &cancellable)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [headerView,textFieldContainerView].forEach(addSubview(_:)) // add many subviews just once
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        textFieldContainerView.addSubview(currencyLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc func doneButtonTapped(){
        textField.endEditing(true)
    }
    
    func reset(){
        textField.text = nil
        billSubject.send(0)
    }
    
}

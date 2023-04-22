//
//  SplitInputView.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView{
    
    private let headerView: HeaderView = {
       let view = HeaderView()
        view.configure(topText: "Split", bottomText: "The total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildButton(text:"-", corners: [.layerMinXMaxYCorner,.layerMinXMinYCorner])
        button.tapPublisher.flatMap { _ in
            Just(self.splitSubject.value == 1 ? 1 : self.splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(text:"+", corners: [.layerMaxXMinYCorner,.layerMaxXMaxYCorner])
        button.tapPublisher.flatMap { _ in
            Just(self.splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellable)
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20))
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
       ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    private var cancellable = Set<AnyCancellable>()
    private lazy var splitSubject: CurrentValueSubject<Int,Never> = .init(1)
    var valuePublisher: AnyPublisher<Int,Never>{
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    init(){
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [headerView,stackView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(68)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton,decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
    }
    
    private func buildButton(text: String,corners:CACornerMask) -> UIButton{
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.addRoundedCorners(corners: corners, radius: 8)
        return button
    }
    
    private func observe(){
        splitSubject.sink { value in
            self.quantityLabel.text = value.stringValue
        }.store(in: &cancellable)
    }
    
    func reset(){
        splitSubject.send(1)
    }
}


//
//  SplitInputView.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit

class SplitInputView: UIView{
    
    private let headerView: HeaderView = {
       let view = HeaderView()
        view.configure(topText: "Split", bottomText: "The total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildButton(text:"-", corners: [.layerMinXMaxYCorner,.layerMinXMinYCorner])
       
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(text:"+", corners: [.layerMaxXMinYCorner,.layerMaxXMaxYCorner])
       
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
    
    init(){
        super.init(frame: .zero)
        layout()
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
    
}


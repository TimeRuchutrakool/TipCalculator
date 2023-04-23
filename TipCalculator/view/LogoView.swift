//
//  LogoView.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit

class LogoView: UIView{
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "calculator"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: "Dr TIP", attributes: [.font:ThemeFont.demibold(ofSize: 16)])
        //font fot TIP word
        text.addAttributes([.font:ThemeFont.bold(ofSize: 24)], range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(text: "Calculator", font: ThemeFont.demibold(ofSize: 20),textAlignment: .left)
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topLabel,
            bottomLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = -4
        //stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            vStackView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    init(){
        super.init(frame: .zero)
        accessibilityIdentifier = ScreenIdentifier.LogoView.logoView.rawValue
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width) // make ratio
        }
    }
    
}

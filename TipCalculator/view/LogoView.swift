//
//  LogoView.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit

class LogoView: UIView{
    
    init(){
        super.init(frame: .zero)
        layout()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        backgroundColor = .red
    }
    
}

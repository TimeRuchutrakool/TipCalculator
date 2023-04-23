//
//  ScreenIdentifier.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/23/23.
//

import Foundation

enum ScreenIdentifier{
    
    enum LogoView: String{
        case logoView
    }
    
    enum ResultView:String{
        case totalAmountPerPersonValueLabel
        case totalBillValueLabel
        case totalTipValueLabel
    }
    
    enum BillInputView: String{
        case textField
    }
    
    enum TipInputView: String{
        case tenPercentsButton
        case fifteenPercentsButton
        case twentyPercentsButton
        case customTipButton
        case customTipAlertTextField
    }
    
    enum SplitInputView: String{
        case decrementButton
        case incrementButton
        case quantityValueLabel
    }
    
}

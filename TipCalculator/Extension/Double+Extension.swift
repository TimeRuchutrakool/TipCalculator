//
//  Double+Extension.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/22/23.
//

import Foundation

extension Double{
    var currencyFormatted: String{
        var isWholeNumber: Bool{
            isZero ? true: !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }
}

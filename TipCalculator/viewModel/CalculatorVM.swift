//
//  CalculatorViewModel.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import Foundation
import Combine

class CalculatorVM{
    
    struct Input{
        let billPublisher: AnyPublisher<Double,Never>
        let tipPublisher: AnyPublisher<Tip,Never>
        let splitPublisher: AnyPublisher<Int,Never>
    }
    
    struct Output{
        let updateViewPublisher: AnyPublisher<Result,Never>
    }
    
    //Binding
    func transform(input:Input) -> Output{
        let result = Result(amountPerPerson: 500, totalBill: 1000, totalTip: 50)
        
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
    
}

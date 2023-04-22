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
        let logoViewTapPublisher: AnyPublisher<Void,Never>
    }
    
    struct Output{
        let updateViewPublisher: AnyPublisher<Result,Never>
        let resetCalculatorPublisher: AnyPublisher<Void,Never>
    }
    
    // dependencies injection
    private let audioPlayerServices: AudioPlayerService
    init(audioPlayerServices: AudioPlayerService = DefaultAudioPlayer()){
        self.audioPlayerServices = audioPlayerServices
    }
    
    private var cancellable = Set<AnyCancellable>()
    //Binding
    func transform(input:Input) -> Output{
        // to observe any of these publishers changed
        let updateViewPublisher = Publishers.CombineLatest3(input.billPublisher, input.tipPublisher, input.splitPublisher)
            .flatMap { (bill,tip,split) in
                let totalTip = self.getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                
                let result = Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resultCalculatorPublisher = input.logoViewTapPublisher.handleEvents (receiveOutput: { _ in
            self.audioPlayerServices.playSound()
        }).flatMap { _ in
            return Just(())
        }.eraseToAnyPublisher()
        
        return Output(updateViewPublisher: updateViewPublisher, resetCalculatorPublisher: resultCalculatorPublisher)
    }
 
    func getTipAmount(bill:Double,tip:Tip) -> Double{
        switch tip{
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(value: let value):
            return Double(value)
        }
    }
    
}

//
//  TipCalculatorTests.swift
//  TipCalculatorTests
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import XCTest
import Combine
@testable import TipCalculator

final class TipCalculatorTests: XCTestCase {
    
    private var sut: CalculatorVM!
    private var cancellable: Set<AnyCancellable>!
    
    private var logoViewTapSubject: PassthroughSubject<Void,Never>!
    private var audioPlayerService: MockAudioPlayerService!
    
    override func setUp() {
        audioPlayerService = .init()
        sut = .init(audioPlayerServices: audioPlayerService)
        cancellable = .init()
        logoViewTapSubject = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellable = nil
        logoViewTapSubject = nil
        audioPlayerService = nil
    }
    
    private func buildInput(bill:Double,tip:Tip,split:Int) -> CalculatorVM.Input{
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
    
    func test_result_without_tip_for_a_person(){
        //given
        let bill : Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellable)
    }
    
    func test_result_without_tip_for_2_persons(){
        //given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let outout = sut.transform(input: input)
        //then
        outout.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50.0)
            XCTAssertEqual(result.totalBill, 100.0)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellable)
    }
    
    func test_result_with_10percents_tip_for_2_persons(){
        //given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let outout = sut.transform(input: input)
        //then
        outout.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55.0)
            XCTAssertEqual(result.totalBill, 110.0)
            XCTAssertEqual(result.totalTip, 10.0)
        }.store(in: &cancellable)
    }
    
    func test_result_with_custom_tip_for_4_persons(){
        //given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 20)
        let split: Int = 4
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let outout = sut.transform(input: input)
        //then
        outout.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 30.0)
            XCTAssertEqual(result.totalBill, 120.0)
            XCTAssertEqual(result.totalTip, 20.0)
        }.store(in: &cancellable)
    }
    
    func test_sound_played_abd_calculator_reset_on_logo_tapped(){
        //given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "reset calculator called")
        
        let expectation2 = audioPlayerService.expectation
        //then
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellable)
        //when async
        logoViewTapSubject.send()
        wait(for: [expectation1,expectation2], timeout: 1.0)
    }

}

class MockAudioPlayerService: AudioPlayerService{
    
    var expectation = XCTestExpectation(description: "playsound is called")
    
    func playSound() {
        expectation.fulfill()
    }
}

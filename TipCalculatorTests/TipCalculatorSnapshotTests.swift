//
//  TipCalculatorSnapshotTests.swift
//  TipCalculatorTests
//
//  Created by Time Ruchutrakool on 4/23/23.
//

import XCTest
import SnapshotTesting
@testable import TipCalculator

final class TipCalculatorSnapshotTest: XCTestCase{
    
    private var screenWidths: CGFloat{
        return UIScreen.main.bounds.width
    }
    
    func test_LogoView(){
        //given
        let size = CGSize(width: screenWidths, height: 48)
        //when
        let view = LogoView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_initial_ResultView(){
        //given
        let size = CGSize(width: screenWidths, height: 224)
        //when
        let view = ResultView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_ResultView_with_value(){
        //given
        let size = CGSize(width: screenWidths, height: 224)
        //when
        let view = ResultView()
        view.configure(result: Result(amountPerPerson: 115, totalBill: 200, totalTip: 30))
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_initial_TipInputView(){
        //given
        let size = CGSize(width: screenWidths, height: 56+56+16)
        //when
        let view = TipInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_TipInputView_with_value(){
        //given
        let size = CGSize(width: screenWidths, height: 56+56+16)
        //when
        let view = TipInputView()
        let button = view.allSubViewOf(type: UIButton.self).first
        button?.sendActions(for: .touchUpInside)
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_initial_BillInputView(){
        //given
        let size = CGSize(width: screenWidths, height: 56)
        //when
        let view = BillingInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_BillInputView_with_value(){
        //given
        let size = CGSize(width: screenWidths, height: 56)
        //when
        let view = BillingInputView()
        let textField = view.allSubViewOf(type: UITextView.self).first
        textField?.text = "500"
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_initial_SplitInputView(){
        //given
        let size = CGSize(width: screenWidths, height: 56)
        //when
        let view = SplitInputView()
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func test_SplitInputView_with_value(){
        //given
        let size = CGSize(width: screenWidths, height: 56)
        //when
        let view = SplitInputView()
        let button = view.allSubViewOf(type: UIButton.self).last
        button?.sendActions(for: .touchUpInside)
        //then
        assertSnapshot(matching: view, as: .image(size: size))
    }
}

extension UIView{
    
    //func to get all the subviews of our view
    func allSubViewOf<T : UIView>(type:T.Type) -> [T]{
        var all = [T]()
        func getSubView(view:UIView){
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count > 0 else {return}
            view.subviews.forEach{getSubView(view:$0)}
        }
        getSubView(view: self)
        return all
        
    }
}

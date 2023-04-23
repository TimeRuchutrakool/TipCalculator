//
//  CalculatorScreen.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/23/23.
//

import XCTest

class CalculatorScreen{
    
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    //MARK: - LogoView
    var logoView: XCUIElement{
        return app.otherElements[ScreenIdentifier.LogoView.logoView.rawValue]
    }
    
    //MARK: - ResultView
    var totalAmountPerPersonValueLabel: XCUIElement{
        return app.staticTexts[ScreenIdentifier.ResultView.totalAmountPerPersonValueLabel.rawValue]
    }
    
    var totalBillValueLabel: XCUIElement{
        return app.staticTexts[ScreenIdentifier.ResultView.totalBillValueLabel.rawValue]
    }
    
    var totalTipValueLabel: XCUIElement{
        return app.staticTexts[ScreenIdentifier.ResultView.totalTipValueLabel.rawValue]
    }
    
    //MARK: - BillInputView
    
    var billInputViewTextField: XCUIElement{
        return app.textFields[ScreenIdentifier.BillInputView.textField.rawValue]
    }
    
    //MARK: - TipInputView
    
    var tenPercentsButton: XCUIElement{
        return app.buttons[ScreenIdentifier.TipInputView.tenPercentsButton.rawValue]
    }
    
    var fifteenPercentsButton: XCUIElement{
        return app.buttons[ScreenIdentifier.TipInputView.fifteenPercentsButton.rawValue]
    }
    
    var twentyPercentsButton: XCUIElement{
        return app.buttons[ScreenIdentifier.TipInputView.twentyPercentsButton.rawValue]
    }
    
    var customTipButton: XCUIElement{
        return app.buttons[ScreenIdentifier.TipInputView.customTipButton.rawValue]
    }
    
    var customTipAlertTextField: XCUIElement{
        return app.textFields[ScreenIdentifier.TipInputView.customTipAlertTextField.rawValue]
    }
    
    //MARK: - SplitInputView
    
    var decrementButton: XCUIElement{
        return app.buttons[ScreenIdentifier.SplitInputView.decrementButton.rawValue]
    }
    
    var incrementButton: XCUIElement{
        return app.buttons[ScreenIdentifier.SplitInputView.incrementButton.rawValue]
    }
    
    var quantityValueLabel: XCUIElement{
        return app.staticTexts[ScreenIdentifier.SplitInputView.quantityValueLabel.rawValue]
    }
    
    //MARK: - Actions
    
    enum Tip{
        case ten
        case fifteen
        case twenty
        case custom(value: Int)
    }
    
    func enterBill(amount: Double){
        billInputViewTextField.tap()
        billInputViewTextField.typeText("\(amount)\n")
    }
    
    func selectTip(tip: Tip){
        switch tip {
        case .ten:
            tenPercentsButton.tap()
        case .fifteen:
            fifteenPercentsButton.tap()
        case .twenty:
            twentyPercentsButton.tap()
        case .custom(let value):
            customTipButton.tap()
            XCTAssertTrue(customTipAlertTextField.waitForExistence(timeout: 1.0))
            customTipAlertTextField.typeText("\(value)\n")
        }
    }
    
    func selectIncrementButton(numberOfTaps: Int){
        incrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func selectDecrementButton(numberOfTaps: Int){
        decrementButton.tap(withNumberOfTaps: numberOfTaps, numberOfTouches: 1)
    }
    
    func doubleTapLogoView(){
        logoView.tap(withNumberOfTaps: 2, numberOfTouches: 1)
    }
    
}

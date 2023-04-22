//
//  UIResponder+Extension.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/22/23.
//

import UIKit

extension UIResponder{
    
    var parentViewController: UIViewController?{
        return next as? UIViewController ?? next?.parentViewController
    }
    
}

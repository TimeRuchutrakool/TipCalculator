//
//  UIView+Extension.swift
//  TipCalculator
//
//  Created by Time Ruchutrakool on 4/21/23.
//

import UIKit

extension UIView{
    
    func addShadow(offset: CGSize,color: UIColor,radius:CGFloat,opacity:Float){
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

    }
    
    func addCornerRadius(radius:CGFloat){
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRoundedCorners(corners: CACornerMask,radius:CGFloat){
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
    
}

//
//  Globals.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 12/03/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import Foundation
import UIKit


struct Globales {
    func printWSLog(req:URLRequest){
        if(req.httpMethod == "GET"){
            print("Web Service Log - Metodo: GET, URL: \(req.url!)")
        }else if(req.httpMethod == "POST"){
            print("Web Service Log - Metodo: POST, URL: \(req.url!)")
        }
        
    }
    
    let pedidos = [
        "1":[90,55,80,2,1,2],
        "2":[250,60,90,6,1,6],
        "3":[500,60,90,12,1,12],
        "4":[180,60,90,4,2,2],
        "5":[500,70,95,12,2,6],
        "6":[999,70,95,24,2,12],
        "7":[250,110,180,6,3,2],
        "8":[749,110,180, 18,3,6],
        "9":[1500,150,200,36,3,12]
    ]
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension UIColor {
    func ColorChelero()->UIColor{
        return UIColor().hexStringToUIColor(hex: "#c1996f")
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}

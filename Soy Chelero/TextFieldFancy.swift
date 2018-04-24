//
//  TextFieldFancy.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 17/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TextFieldFancy: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let UIColorChelero = UIColor().hexStringToUIColor(hex: "C4895A")
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColorChelero.cgColor
    }

}

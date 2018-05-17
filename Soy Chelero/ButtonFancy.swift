//
//  ButtonFancy.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 26/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class ButtonFancy: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor().ColorChelero().cgColor
        //self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if (self.tag == 1){
            self.setBackgroundColor(color: UIColor().ColorChelero(), forState: .normal)
            self.setBackgroundColor(color: UIColor.white, forState: .highlighted)
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(UIColor.black, for: .highlighted)
        }else if (self.tag == 0){
            self.setBackgroundColor(color: UIColor().ColorChelero(), forState: .highlighted)
            self.setBackgroundColor(color: UIColor.white, forState: .normal)
            self.setTitleColor(UIColor.white, for: .highlighted)
            self.setTitleColor(UIColor.black, for: .normal)
        }
        
    }
    
    

}

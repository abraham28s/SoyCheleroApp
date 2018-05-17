//
//  TableViewCellDatosBasicos.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TableViewCellDatosBasicos: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var nombreLbl: UILabel!
    @IBOutlet weak var correoLbl: UILabel!
    @IBOutlet weak var telefonoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  TableViewCellDatosEnvio.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TableViewCellDatosEnvio: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var calleNoLbl: UILabel!
    @IBOutlet weak var coloniaLbl: UILabel!
    @IBOutlet weak var municipioLbl: UILabel!
    @IBOutlet weak var estadoCPLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

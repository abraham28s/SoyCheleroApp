//
//  TableViewCellForComments.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 16/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TableViewCellForComments: UITableViewCell {

    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var texto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

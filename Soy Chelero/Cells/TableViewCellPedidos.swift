//
//  TableViewCellPedidos.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 24/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TableViewCellPedidos: UITableViewCell {
    
    @IBOutlet weak var vistaFondo: UIView!
    @IBOutlet weak var fechaLbl: UILabel!
    @IBOutlet weak var paqueteLbl: UILabel!
    @IBOutlet weak var precioLbl: UILabel!
    @IBOutlet weak var tipoTarjetaLbl: UILabel!
    @IBOutlet weak var terminacionTarjetaLBL: UILabel!
    @IBOutlet weak var tipoLbl: UIImageView!
    @IBOutlet weak var estatusImg: UIImageView!
    @IBOutlet weak var estatusLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vistaFondo.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

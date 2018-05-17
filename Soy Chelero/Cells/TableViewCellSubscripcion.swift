//
//  TableViewCellSubscripcion.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 14/05/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit

class TableViewCellSubscripcion: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var estatusLbl: UILabel!
    @IBOutlet weak var recibirImg: UIImageView!
    @IBOutlet weak var recibirLbl: UILabel!
    @IBOutlet weak var conImg: UIImageView!
    @IBOutlet weak var conLbl: UILabel!
    @IBOutlet weak var totalImg: UIImageView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var tipoTarjetaImg: UIImageView!
    @IBOutlet weak var terminacionTarjeta: UILabel!
    @IBOutlet weak var subscripcionLbl: UILabel!
    @IBOutlet weak var proximoCobroLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

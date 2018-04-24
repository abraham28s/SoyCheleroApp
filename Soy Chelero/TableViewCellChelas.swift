//
//  TableViewCellChelas.swift
//  Soy Chelero
//
//  Created by Abraham Soto on 17/04/18.
//  Copyright © 2018 Abraham. All rights reserved.
//

import UIKit
import Cosmos
import MIBadgeButton_Swift

class TableViewCellChelas: UITableViewCell {
    @IBOutlet weak var vistaFondo: UIView!
    @IBOutlet weak var nombreLbl: UILabel!
    @IBOutlet weak var imageImg: UIImageView!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var commentsBtn: MIBadgeButton!
    
    @IBOutlet weak var masInfoBTn: UIButton!
    
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

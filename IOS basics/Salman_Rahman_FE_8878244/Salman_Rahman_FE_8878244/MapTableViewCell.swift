//
//  MapTableViewCell.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/9/23.
//

import UIKit

class MapTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var startPoint: UILabel!
    
    @IBOutlet weak var endPoint: UILabel!
    @IBOutlet weak var modeOfTravel: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var from: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

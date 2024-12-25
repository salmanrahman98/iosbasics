//
//  WeatherTableViewCell.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/9/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var date: UILabel!
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

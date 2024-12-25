//
//  NewsTableViewCell.swift
//  Salman_Rahman_FE_8878244
//
//  Created by user223067 on 12/2/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
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

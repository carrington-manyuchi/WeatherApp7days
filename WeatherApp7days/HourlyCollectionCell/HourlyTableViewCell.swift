//
//  HourlyTableViewCell.swift
//  WeatherApp7days
//
//  Created by Carrington Tafadzwa Manyuchi on 2023/04/21.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Adding the  identifier and Nib functions  to register the cells
    static let identifier  = "HourlyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
}




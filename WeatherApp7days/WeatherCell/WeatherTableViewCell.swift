//
//  WeatherTableViewCell.swift
//  WeatherApp7days
//
//  Created by Carrington Tafadzwa Manyuchi on 2023/04/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //backgroundColor = .cyan
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
     
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: Daily){
        
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        
        
        self.lowTempLabel.text = "\(Int(model.temp.min))°"
        self.highTempLabel.text = "\(Int(model.temp.max))°"
        self.dayLabel.text =  getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.iconImageView.image = UIImage(named: "sun")
        self.iconImageView.contentMode = .scaleAspectFit
 
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
    
}

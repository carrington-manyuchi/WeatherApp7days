//
//  WeatherCollectionViewCell.swift
//  WeatherApp7days
//
//  Created by Carrington Tafadzwa Manyuchi on 2023/04/21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    func configure(with model: Current) {
        self.tempLabel.text = "\(model.temp)"
        self.iconImageView.contentMode = .scaleAspectFit
       self.iconImageView.image = UIImage(named: "rain")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  CitiesTableViewCell.swift
//  Weather
//
//  Created by Матвей on 27.04.2022.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily) {
        self.cityLabel.text = model.dayOfWeek
        self.minTemp.text = "\(Int(model.temp.min))°"
        self.maxTemp.text = "\(Int(model.temp.max))°"
        self.iconImage.image = model.weather.first?.daySfIcon
    }

}

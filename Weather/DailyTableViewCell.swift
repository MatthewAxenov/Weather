//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Матвей on 05.04.2022.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    var current = [Current]()

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily, secondModel: Current) {
        self.dayLabel.text = model.dayOfWeek
        self.minTemp.text = "\(Int(model.temp.min))°"
        self.maxTemp.text = "\(Int(model.temp.max))°"
        if current.first?.dayOrNight == "День" {
            self.iconImage.image = model.weather.first?.daySfIcon
        } else {
            self.iconImage.image = model.weather.first?.daySfIcon.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
        
    }
    

}

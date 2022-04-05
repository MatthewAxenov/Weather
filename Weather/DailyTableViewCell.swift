//
//  DailyTableViewCell.swift
//  Weather
//
//  Created by Матвей on 05.04.2022.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

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
    
    func configure(with model: Daily) {
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.minTemp.text = "\(Int(model.temp.min))°"
        self.maxTemp.text = "\(Int(model.temp.max))°"
        self.iconImage.image = model.weather.first?.daySfIcon
        
    }
    
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate).capitalized
    }

}

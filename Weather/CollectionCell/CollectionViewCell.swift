//
//  CollectionViewCell.swift
//  Weather
//
//  Created by Матвей on 06.04.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    static let idendifier = "CollectionViewCell"
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    func configure(with model: Current) {
        self.tempLabel.text = "\(Int(model.temp))°"
        
        let date = Date(timeIntervalSince1970: Double(model.dt))
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH"
        let hourString = formatter.string(from: date)
    
        self.hourLabel.text = "\(hourString)"
        
        self.iconImageView.image = model.weather.first?.daySfIcon
        
    }
    


    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

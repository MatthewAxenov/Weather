//
//  DetailedViewController.swift
//  Weather
//
//  Created by Матвей on 06.04.2022.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var dailyModel: Daily?
    
    var backGroundColor: UIColor?
    
    var current: Current?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var windBlockImage: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var precipitationBlockImage: UIImageView!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    @IBOutlet weak var descriptionBlockImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBOutlet weak var pressureBlockImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityBlockImage: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var sunDayBlockImage: UIImageView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backGroundColor
        updateInterface()


    }
    
    func updateInterface() {
        guard let models = dailyModel else { return }
        minTempLabel.text = "\(Int(models.temp.min))°"
        maxTempLabel.text = "\(Int(models.temp.max))°"
        image.image = models.weather.first?.daySfIcon
        if current?.dayOrNight == "Ночь" {
            image.tintColor = .white
        }
        titleLabel.text = "\(models.dayOfWeek), \(models.date)"

        windBlockImage.layer.cornerRadius = 15
        windSpeedLabel.text = "\(models.windSpeed) м/с"
        
        precipitationBlockImage.layer.cornerRadius = 15
        precipitationLabel.text = "\(Int(models.pop * 100))%, \(models.rainVolume) мм"
        
        descriptionBlockImage.layer.cornerRadius = 15
        descriptionLabel.text = models.weather.first?.conditionString
        feelsLikeLabel.text = "Ощущается как \(Int(models.feelsLike.day))° днем и \(Int(models.feelsLike.night))° ночью"
        
        pressureBlockImage.layer.cornerRadius = 15
        pressureLabel.text = "\(models.pressure) мм"
        
        humidityBlockImage.layer.cornerRadius = 15
        humidityLabel.text = "\(Int(models.humidity)) %"
        
        sunDayBlockImage.layer.cornerRadius = 15
        sunriseLabel.text = models.sunriseHour
        sunsetLabel.text = models.sunsetHour
        
    }
    
}

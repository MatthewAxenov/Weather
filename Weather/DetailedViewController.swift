//
//  DetailedViewController.swift
//  Weather
//
//  Created by Матвей on 06.04.2022.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var models: Daily?
    
    var backGroundColor: UIColor?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var windBlockImage: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var precipitationBlockImage: UIImageView!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backGroundColor
        updateInterface()


    }
    
    func updateInterface() {
        guard let models = models else { return }
        minTempLabel.text = "\(Int(models.temp.min))°"
        maxTempLabel.text = "\(Int(models.temp.max))°"
        image.image = models.weather.first?.daySfIcon
        titleLabel.text = "\(models.dayOfWeek), \(models.date)"

        windBlockImage.layer.cornerRadius = 15
        windSpeedLabel.text = "\(models.windSpeed) м/с"
        
        precipitationBlockImage.layer.cornerRadius = 15
        precipitationLabel.text = "\(Int(models.pop * 100))%, \(models.rainVolume) мм"
    }
    
    

    

}

//
//  ViewController.swift
//  Weather
//
//  Created by Матвей on 04.04.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //MARK: Models
    
    var models = [Daily]()
    var hourlyModels = [Current]()
    
    //MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    
    
    //MARK: Location properties
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: Current?
    var currentCity: String?
    
    //MARK: viewDid


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    //MARK: Location
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
            let geocoder = CLGeocoder()
            guard let currentLocation = currentLocation else {
                return
            }
            geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
                if error != nil {
                    print("Error")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count > 0 {
                    let placemark = placemarks![0]
                    let locality = placemark.locality
                    self.currentCity = locality
                }
            }
        }
    }
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }

        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&units=metric&exclude=minutely,alerts&appid=9894cc37ab883d54f528cf8b18f67b95"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("Что-то пошло не так")
                return
            }
            
            var json: Welcome?

            do {
                json = try JSONDecoder().decode(Welcome.self, from: data)
            } catch {
                print("error: \(error)")
                return
            }

            guard let result = json else {
                return
            }
            
            let entries = result.daily
            
            self.models.append(contentsOf: entries)
            
            let current = result.current
            self.current = current
            self.hourlyModels = result.hourly
            
            DispatchQueue.main.async {
                self.updateCurrentInterface()
                self.tableView.reloadData()
            }
        }).resume()
    }
    
    //MARK: UpdateCurrentInterface
    
    func updateCurrentInterface() {
        
        guard let current = self.current else { return }
        
        dayOrNight()
        
        self.cityLabel.text = currentCity
        self.descriptionLabel.text = "\(current.weather.first!.conditionString)"
        self.currentTemp.text = "\(Int(current.temp))°"
        self.feelsLikeLabel.text = "Ощущается как \(Int(current.feelsLike))°"
        self.windSpeedLabel.text = "\(Int(current.windSpeed)) м/с"
        self.humidityLabel.text = "\(Int(current.humidity)) %"
    }
    
    func dayOrNight() {
        
        if current?.dayOrNight == "Ночь" {
            self.view.backgroundColor = UIColor(named: "DayBackground")
            self.tableView.backgroundColor = UIColor(named: "DayBackground")
            self.currentWeatherIcon.image = current!.weather.first?.daySfIcon
        } else {
            self.view.backgroundColor = UIColor(named: "NightBackground")
            self.tableView.backgroundColor = UIColor(named: "NightBackground")
            self.currentWeatherIcon.image = current!.weather.first?.nightSfIcon
        }
    }
    
    
    //MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = tableView.backgroundColor
        return cell
    }

}


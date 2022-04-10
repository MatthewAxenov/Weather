//
//  ViewController.swift
//  Weather
//
//  Created by Матвей on 04.04.2022.
//

import UIKit
import CoreLocation

class MainScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //MARK: Models
    
    var dailyModel = [Daily]()
    var hourlyModel = [Current]()
    
    //MARK: Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windImage: UIImageView!
    @IBOutlet weak var humidityImage: UIImageView!
    
    
    
    
    
    //MARK: Location properties
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    public var current: Current? 
    var currentCity: String?
    
    //MARK: life cycle


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            
            self.dailyModel.append(contentsOf: entries)
            
            let current = result.current
            self.current = current
            self.hourlyModel = result.hourly
            
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
        print(current.weather.first?.weatherDescription)
        self.currentTemp.text = "\(Int(current.temp))°"
        self.feelsLikeLabel.text = "Ощущается как \(Int(current.feelsLike))°"
        self.windSpeedLabel.text = "\(Int(current.windSpeed)) м/с"
        self.humidityLabel.text = "\(Int(current.humidity)) %"
    }
    
    func dayOrNight() {
        
        if current?.dayOrNight == "День" {
            self.view.backgroundColor = UIColor(named: "DayBackground")
            self.tableView.backgroundColor = UIColor(named: "DayBackground")
            self.currentWeatherIcon.image = current!.weather.first?.daySfIcon
        } else {
            self.view.backgroundColor = UIColor(named: "NightBackground")
            self.tableView.backgroundColor = UIColor(named: "NightBackground")
            self.currentWeatherIcon.image = current!.weather.first?.nightSfIcon.withTintColor(.white, renderingMode: .alwaysOriginal)
            self.windImage.tintColor = .white
            self.humidityImage.tintColor = .white
        }
    }
    
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dailyModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModel)
            cell.backgroundColor = tableView.backgroundColor
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
        cell.configure(with: dailyModel[indexPath.row])
        if indexPath.row == 0 {
            cell.dayLabel.text = "Сегодня"
        }
        if indexPath.row == 1 {
            cell.dayLabel.text = "Завтра"
        }
        cell.backgroundColor = tableView.backgroundColor
        let backgroundView = UIView()
        backgroundView.backgroundColor = tableView.backgroundColor
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 60
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 10, y: -20, width: headerView.frame.width, height: headerView.frame.height)
            label.text = "Почасовой прогноз"
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .label
            
            headerView.addSubview(label)
            
            return headerView
            } else if section == 1 {
                let headerView1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
                
                let label1 = UILabel()
                label1.frame = CGRect.init(x: 10, y: -20, width: headerView1.frame.width, height: headerView1.frame.height)
                label1.text = "Прогноз по дням"
                label1.font = .systemFont(ofSize: 16, weight: .semibold)
                label1.textColor = .label
                
                headerView1.addSubview(label1)
                return headerView1
            }
        return UIView()
        }
    
    
    //NSArt string
    
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let dailyWeather = dailyModel[indexPath.row]
            let detailedVC = segue.destination as! DetailedViewController
            detailedVC.dailyModel = dailyWeather
            detailedVC.backGroundColor = tableView.backgroundColor
            detailedVC.current = self.current
        }
    }
    
    
}


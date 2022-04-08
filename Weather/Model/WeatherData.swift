//
//  WeatherData.swift
//  Weather
//
//  Created by Матвей on 04.04.2022.
//

import Foundation
import UIKit

// MARK: - Welcome
struct Welcome: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    
    var date: String {
        let date = NSDate(timeIntervalSince1970: Double(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date as Date).capitalized
    }
    
    var dayOfWeek: String {
        let date = NSDate(timeIntervalSince1970: Double(dt))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date as Date).capitalized
    }
    
    let sunrise, sunset: Int?
    
    var sunriseHour: Int {
        guard let sunrise = sunrise else { return 0}
        let date = NSDate(timeIntervalSince1970: Double(sunrise))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let sunsetString = formatter.string(from: date as Date).capitalized
        return Int(sunsetString)!
    }
    
    var sunsetHour: Int {
        guard let sunset = sunset else { return 0}
        let date = NSDate(timeIntervalSince1970: Double(sunset))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let sunsetString = formatter.string(from: date as Date).capitalized
        return Int(sunsetString)!
    }
    
    var dayOrNight: String {
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        if currentHour < sunsetHour && currentHour > sunriseHour {
            return "День"
        } else {
            return "Ночь"
        }
    }
    
    
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
    let snow: Snow?
    let windGust, pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, snow
        case windGust = "wind_gust"
        case pop
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription: String
    let icon: Icon?
    var conditionString: String {
        
        switch weatherDescription {
            
        case "clear sky": return "Ясно"
            
        case "few clouds": return "Небольшие облака"
        case "scattered clouds": return "Малооблачно"
        case "broken clouds": return "Облачно с прояснениями"
        case "overcast clouds": return "Пасмурно"
            
        case "rain": return "дождь"
        case "light rain": return "Небольшой дождь"
        case "moderate rain": return "Умеренно сильный дождь"
        case "heavy intensity rain": return "Сильный дождь"
        case "very heavy rain": return "Очень сильный дождь"
        case "extreme rain": return "Экстримальный дождь"
        case "freezing rain": return "Ледяной дождь"
        case "light intensity shower rain": return "Небольшой грибной дождь"
        case "shower rain": return "Грибной дождь"
        case "heavy intensity shower rain": return "Сильный грибной дождь"
        case "ragged shower rain": return "Косой грибной дождь"
            
        case "light snow": return "Небольшой снег"
        case "snow": return "Снег"
        case "heavy snow": return "Сильный снегопад"
        case "sleet": return "Мокрый снег"
        case "light shower sleet": return "Небольшой мокрый снег"
        case "shower sleet": return "Слякоть"
        case "light rain and snow": return "Небольшой дождь со снегом"
        case "rain and snow": return "Дождь со снегом"
        case "light shower snow": return "Мокрый снег"
        case "shower snow": return "Снежный дождь"
        case "heavy shower snow": return "Сильный снежный дождь"
            
        case "drizzle", "light intensity drizzle", "heavy intensity drizzle", "light intensity drizzle rain", "drizzle rain", "heavy intensity drizzle rain", "shower rain and drizzle", "heavy shower rain and drizzle", "shower drizzle": return "Моросящий дождь"
       
        case "thunderstorm": return "Гроза"
        case "thunderstorm with rain": return "Дождь с грозой"
        case "thunderstorm with light rain", "thunderstorm with heavy rain", "light thunderstorm", "heavy thunderstorm", "ragged thunderstorm", "thunderstorm with light drizzle", "thunderstorm with drizzle", "thunderstorm with heavy drizzle": return "Гроза"
            
        case "mist", "haze", "fog": return "Туман"
            
        default: return "Загрузка..."
            
        }
    }
    
    var daySfIcon: UIImage {
        switch main.rawValue {
        case "Thunderstorm": return UIImage(systemName: "cloud.bolt")!
        case "Drizzle": return UIImage(systemName: "cloud.drizzle")!
        case "Clouds": return UIImage(systemName: "cloud")!
        case "Rain": return UIImage(systemName: "cloud.rain")!
        case "Snow": return UIImage(systemName: "snow")!
        case "Clear": return UIImage(systemName: "sun.min")!
        case "Atmosphere": return UIImage(systemName: "cloud.fog")!
            
        default: return UIImage(systemName: "sun.min")!
        }
    }
    
    var nightSfIcon: UIImage {
        switch main.rawValue {
        case "Thunderstorm": return UIImage(systemName: "cloud.moon.bolt")!
        case "Drizzle": return UIImage(systemName: "cloud.drizzle")!
        case "Clouds": return UIImage(systemName: "cloud.moon")!
        case "Rain": return UIImage(systemName: "cloud.moon.rain")!
        case "Snow": return UIImage(systemName: "snow")!
        case "Clear": return UIImage(systemName: "moon.stars")!
        case "Atmosphere": return UIImage(systemName: "cloud.fog")!
            
        default: return UIImage(systemName: "moon")!
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum Icon: String, Codable {
    case the01N = "01n"
    case the01D = "01d"
    case the02N = "02n"
    case the02D = "02d"
    case the03D = "03d"
    case the03N = "03n"
    case the04D = "04d"
    case the04N = "04n"
    case the10D = "10d"
    case the10N = "10n"
    case the11D = "11d"
    case the11N = "11n"
    case the13D = "13d"
    case the13N = "13n"
    case the50D = "50d"
    case the50N = "50n"
}

enum Main: String, Codable {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
    case clear = "Clear"
    case atmosphere = "Atmosphere"
    case haze = "Haze"
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    var date: String {
        let date = NSDate(timeIntervalSince1970: Double(dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: date as Date).capitalized
    }
    var dayOfWeek: String {
        let date = NSDate(timeIntervalSince1970: Double(dt))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date as Date).capitalized
    }
    var sunriseHour: String {
        let date = NSDate(timeIntervalSince1970: Double(sunrise))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date as Date).capitalized
    }
    var sunsetHour: String {
        let date = NSDate(timeIntervalSince1970: Double(sunset))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: date as Date).capitalized
    }
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let snow: Double?
    let uvi: Double
    let rain: Double?
    var rainVolume: Int {
        if rain == nil {
            return 0
        } else {
        return Int(rain!)
        }
    }

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, snow, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

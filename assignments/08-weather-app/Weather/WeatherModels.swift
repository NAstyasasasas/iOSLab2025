//
//  WeatherModels.swift
//  Weather
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation
import SwiftUI

struct City: Identifiable, Codable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name, latitude, longitude
    }
}

struct WeatherResponse: Codable {
    let main: MainWeather
    let wind: Wind
    let name: String
    
    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case humidity
        }
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}

struct CityWeather: Identifiable, Equatable {
    let id = UUID()
    let city: City
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    
    var temperatureColor: Color {
        if temperature > 25 {
            return .red
        } else if temperature > 15 {
            return .orange
        } else {
            return .blue
        }
    }
    static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
            return lhs.id == rhs.id &&
                lhs.city.name == rhs.city.name &&
                lhs.temperature == rhs.temperature
        }
    }

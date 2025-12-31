//
//  MockWeatherService.swift
//  Weather
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

class MockWeatherService: WeatherServiceProtocol {
    
    func fetchWeather(for city: City) async throws -> CityWeather {
        try await Task.sleep(for: .seconds(0.5))
        
        let randomTemp = Double.random(in: -10...35)
        let randomFeelsLike = randomTemp + Double.random(in: -3...3)
        let randomHumidity = Int.random(in: 30...90)
        let randomWind = Double.random(in: 0...15)
        
        return CityWeather(
            city: city,
            temperature: randomTemp,
            feelsLike: randomFeelsLike,
            humidity: randomHumidity,
            windSpeed: randomWind
        )
    }
}

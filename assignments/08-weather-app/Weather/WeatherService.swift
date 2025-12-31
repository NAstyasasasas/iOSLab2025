//
//  WeatherService.swift
//  Weather
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
}

protocol WeatherServiceProtocol {
    func fetchWeather(for city: City) async throws -> CityWeather
}

class WeatherService: WeatherServiceProtocol {
    
    private let apiKey = ""
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchWeather(for city: City) async throws -> CityWeather {
        guard let url = URL(string: "\(baseURL)?lat=\(city.latitude)&lon=\(city.longitude)&appid=\(apiKey)&units=metric") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            
            return CityWeather(
                city: city,
                temperature: weatherResponse.main.temp,
                feelsLike: weatherResponse.main.feelsLike,
                humidity: weatherResponse.main.humidity,
                windSpeed: weatherResponse.wind.speed
            )
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingFailed
        }
    }
}

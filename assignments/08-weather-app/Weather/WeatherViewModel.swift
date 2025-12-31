//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation
import Observation

@Observable
final class WeatherViewModel {
    
    enum State: Equatable {
        case loading
        case empty
        case content
        case error(String)
    }
    
    var cityWeather: [CityWeather] = []
    var filteredCityWeather: [CityWeather] = []
    var state: State = .loading
    var searchText = ""
    
    private let service: WeatherServiceProtocol
    private let cities: [City] = [
        City(name: "Moscow", latitude: 55.7558, longitude: 37.6173),
        City(name: "London", latitude: 51.5074, longitude: -0.1278),
        City(name: "New York", latitude: 40.7128, longitude: -74.0060),
        City(name: "Tokyo", latitude: 35.6762, longitude: 139.6503),
        City(name: "Sydney", latitude: -33.8688, longitude: 151.2093),
        City(name: "Berlin", latitude: 52.5200, longitude: 13.4050),
        City(name: "Paris", latitude: 48.8566, longitude: 2.3522),
        City(name: "Rome", latitude: 41.9028, longitude: 12.4964)
    ]
    
    init(service: WeatherServiceProtocol) {
        self.service = service
    }
    
    @MainActor
    func loadWeather() async {
        state = .loading
        
        do {
            let weatherData = try await withThrowingTaskGroup(of: CityWeather.self) { group in
                for city in cities {
                    group.addTask {
                        try await self.service.fetchWeather(for: city)
                    }
                }
                
                var collectedWeather: [CityWeather] = []
                for try await weather in group {
                    collectedWeather.append(weather)
                }
                return collectedWeather
            }
            
            cityWeather = weatherData
            updateFilteredCities()
            state = cityWeather.isEmpty ? .empty : .content
        } catch {
            state = .error("Failed to load weather data: \(error.localizedDescription)")
            cityWeather = []
            filteredCityWeather = []
        }
    }
    
    func updateFilteredCities() {
        if searchText.isEmpty {
            filteredCityWeather = cityWeather
        } else {
            filteredCityWeather = cityWeather.filter { cityWeather in
                cityWeather.city.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func sortByTemperature(ascending: Bool = false) {
        if ascending {
            filteredCityWeather.sort { $0.temperature < $1.temperature }
        } else {
            filteredCityWeather.sort { $0.temperature > $1.temperature }
        }
    }
    
    func retry() {
        Task {
            await loadWeather()
        }
    }
}

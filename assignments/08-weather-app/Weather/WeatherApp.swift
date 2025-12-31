//
//  WeatherApp.swift
//  Weather
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    @State private var viewModel = WeatherViewModel(service: MockWeatherService())

    var body: some Scene {
        WindowGroup {
            WeatherListView(viewModel: viewModel)
        }
    }
}

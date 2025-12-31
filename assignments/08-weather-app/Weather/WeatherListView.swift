//
//  WeatherListView.swift
//  Weather
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct WeatherListView: View {
    @Bindable var viewModel: WeatherViewModel
    @State private var sortAscending = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading weather...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .empty:
                    EmptyStateView(
                        title: "No weather data",
                        subtitle: "Try reloading the app"
                    )
                    
                case .content:
                    weatherList
                    
                case .error(let message):
                    ErrorView(message: message) {
                        viewModel.retry()
                    }
                }
            }
            .navigationTitle("Weather Cities")
            .task {
                await viewModel.loadWeather()
            }
            .refreshable {
                await viewModel.loadWeather()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search city...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.searchText) {
                    viewModel.updateFilteredCities()
                }
            
            Button(action: {
                sortAscending.toggle()
                viewModel.sortByTemperature(ascending: sortAscending)
            }) {
                Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var weatherList: some View {
        List(viewModel.filteredCityWeather) { cityWeather in
            WeatherRow(cityWeather: cityWeather)
                .listRowSeparator(.hidden)
                .padding(.vertical, 4)
        }
        .listStyle(.plain)
        .animation(.easeInOut(duration: 0.3), value: viewModel.filteredCityWeather.count)
    }
}

struct WeatherRow: View {
    let cityWeather: CityWeather
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(cityWeather.city.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Feels like: \(Int(cityWeather.feelsLike))°C")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "humidity")
                        .foregroundColor(.blue)
                    Text("\(cityWeather.humidity)%")
                        .font(.caption)
                    
                    Image(systemName: "wind")
                        .foregroundColor(.gray)
                    Text("\(Int(cityWeather.windSpeed)) m/s")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Text("\(Int(cityWeather.temperature))°C")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(cityWeather.temperatureColor)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
        )
    }
}

struct ErrorView: View {
    let message: String
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

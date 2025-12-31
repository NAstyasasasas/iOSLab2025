//
//  CryptoViewModel.swift
//  CryptoApp
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation
import Observation

@Observable
final class CryptoViewModel {
    
    enum State: Equatable {
        case loading
        case empty
        case content
        case error(String)
    }
    
    var cryptoList: [Crypto] = []
    var state: State = .loading
    var sortByPriceDescending = true
    
    private let service: CryptoService
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func load() async {
        state = .loading
        
        do {
            var loadedCrypto = try await service.obtainCryptoList()
            if sortByPriceDescending {
                loadedCrypto.sort { $0.currentPrice > $1.currentPrice }
            } else {
                loadedCrypto.sort { $0.currentPrice < $1.currentPrice }
            }
            
            cryptoList = loadedCrypto
            state = cryptoList.isEmpty ? .empty : .content
        } catch NetworkError.decodingFailed {
            cryptoList = []
            state = .error("Failed to decode response")
        } catch let NetworkError.badStatusCode(code) {
            cryptoList = []
            state = .error("Server error: \(code)")
        } catch NetworkError.invalidURL {
            cryptoList = []
            state = .error("Invalid URL")
        } catch {
            cryptoList = []
            state = .error("Network error occurred")
        }
    }
    
    func toggleSortOrder() {
        sortByPriceDescending.toggle()
        if sortByPriceDescending {
            cryptoList.sort { $0.currentPrice > $1.currentPrice }
        } else {
            cryptoList.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    func getTopGainers() -> [Crypto] {
        return cryptoList
            .filter { $0.priceChangePercentage24h ?? 0 > 0 }
            .sorted { ($0.priceChangePercentage24h ?? 0) > ($1.priceChangePercentage24h ?? 0) }
            .prefix(5)
            .map { $0 }
    }
}

//
//  CryptoService.swift
//  CryptoApp
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

protocol CryptoService {
    func obtainCryptoList() async throws -> [Crypto]
}

enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed
    case noInternet
}

class RealCryptoService: CryptoService {
    
    private let cryptoURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100"
    private let urlSession: URLSession
    private lazy var decoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    private var cachedCrypto: [Crypto]?
    private var lastFetchDate: Date?
    private let cacheExpiration: TimeInterval = 60 // 1 минута кэша
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func obtainCryptoList() async throws -> [Crypto] {
        if let cachedCrypto = cachedCrypto,
           let lastFetchDate = lastFetchDate,
           Date().timeIntervalSince(lastFetchDate) < cacheExpiration {
            return cachedCrypto
        }
        
        guard let url = URL(string: cryptoURL) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10
        
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.badStatusCode(http.statusCode)
        }
        
        do {
            let cryptoList = try decoder.decode([Crypto].self, from: data)
            
            cachedCrypto = cryptoList
            lastFetchDate = Date()
            
            return cryptoList
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

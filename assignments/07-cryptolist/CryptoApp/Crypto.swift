//
//  Crypto.swift
//  CryptoApp
//
//  Created by Анастасия on 31.12.2025.
//

import Foundation

struct Crypto: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let symbol: String
    let currentPrice: Double
    let image: String
    let priceChangePercentage24h: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case currentPrice = "current_price"
        case image
        case priceChangePercentage24h = "price_change_percentage_24h"
    }
}

extension Crypto {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: currentPrice)) ?? "$\(currentPrice)"
    }
}

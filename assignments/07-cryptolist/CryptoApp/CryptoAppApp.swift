//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @State private var viewModel = CryptoViewModel(service: RealCryptoService())
    
    var body: some Scene {
        WindowGroup {
            CryptoListView(viewModel: viewModel)
        }
    }
}

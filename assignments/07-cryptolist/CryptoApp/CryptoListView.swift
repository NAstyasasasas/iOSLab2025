//
//  CryptoListView.swift
//  CryptoApp
//
//  Created by Анастасия on 31.12.2025.
//

import SwiftUI

struct CryptoListView: View {
    @Bindable var viewModel: CryptoViewModel
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Cryptocurrencies")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.toggleSortOrder()
                        }) {
                            Image(systemName: viewModel.sortByPriceDescending ?
                                  "arrow.down.circle" : "arrow.up.circle")
                            .font(.headline)
                        }
                    }
                }
                .task {
                    await viewModel.load()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, minHeight: 200)
        case .empty:
            CryptoEmptyStateView(
                title: "No cryptocurrencies",
                subtitle: "Try reloading later"
            )
        case .content:
            List {
                if !viewModel.getTopGainers().isEmpty {
                    Section("🔥 Top Gainers") {
                        ForEach(viewModel.getTopGainers()) { crypto in
                            CryptoRow(crypto: crypto, isGainer: true)
                        }
                    }
                }
                
                Section("All Cryptocurrencies") {
                    ForEach(viewModel.cryptoList) { crypto in
                        CryptoRow(crypto: crypto, isGainer: false)
                    }
                }
            }
            .refreshable {
                await viewModel.load()
            }
        case .error(let message):
            CryptoErrorView(message: message) {
                Task { await viewModel.load() }
            }
        }
    }
}

struct CryptoRow: View {
    let crypto: Crypto
    let isGainer: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: crypto.image)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Image(systemName: "bitcoinsign.circle")
                        .foregroundStyle(.gray)
                } else {
                    ProgressView()
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(crypto.name)
                        .font(.headline)
                    Text("(\(crypto.symbol.uppercased()))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(crypto.formattedPrice)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()

            if let change = crypto.priceChangePercentage24h {
                Text(String(format: "%.2f%%", change))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(change >= 0 ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill((change >= 0 ? Color.green : Color.red).opacity(0.1))
                    )
            }
        }
        .padding(.vertical, 4)
        .listRowBackground(isGainer ? Color.green.opacity(0.05) : Color.clear)
    }
}

struct CryptoErrorView: View {
    let message: String
    var onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "network.slash")
                .font(.system(size: 50))
                .foregroundStyle(.red)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

struct CryptoEmptyStateView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.downtrend.xyaxis")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
            
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            
            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
    }
}

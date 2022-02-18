//
//  HomeViewModel.swift
//  CrytoWallet
//
//  Created by Isaac on 09/02/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var  stadisticas: [StadisticasModelo] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portafolioCoin: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let CoindataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
   addSubscribers()
    }
    
    func addSubscribers() {
      
        
        $searchText
            .combineLatest(CoindataService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.stadisticas = returnedStats
            }
            .store(in: &cancellables)

    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let minisculaText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(minisculaText) ||
            coin.symbol.lowercased().contains(minisculaText) ||
            coin.id.lowercased().contains(minisculaText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StadisticasModelo] {
        var stas: [StadisticasModelo] = []
        
        guard let data = marketDataModel else {
            return stas
        }
        
        let marketCap = StadisticasModelo(title: "Portafolio Value", value: "$0.0", percentageChange: 0)
        let portafolio = StadisticasModelo(title: "Market Cap", value: data.marketcap, percentageChange: data.marketCapChangePercentage24HUsd)
        let btcDominance = StadisticasModelo(title: "BTC Dominance", value: data.btcDominance)
        let volume = StadisticasModelo(title: "24h Volume", value: data.volume)
        
                         
        
        stas.append(contentsOf: [
        marketCap,
        portafolio,
        btcDominance,
        volume,
       
       
    
        ])
        return stas
    }
    
}

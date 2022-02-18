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
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    private let CoindataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portafolioDataService = PortafolioDataService()
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
        //update marketCap
        marketDataService.$marketData
            .combineLatest($portafolioCoin)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.stadisticas = returnedStats
            }
            .store(in: &cancellables)
        
        //update portafolioCoins
        $allCoins
            .combineLatest(portafolioDataService.$saveEntities)
            .map{(CoinModel, PortafolioEntity) -> [CoinModel] in
                CoinModel
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = PortafolioEntity.first(where: { $0.coinID == coin.id  }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnCoins) in
                self?.portafolioCoin = returnCoins
                self?.isLoading = false
            }
            .store(in: &cancellables)

    }
    
    func updatePortafolio(coin: CoinModel, amount: Double) {
        portafolioDataService.updatePortafolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        CoindataService.getCoins()
        marketDataService.getDataMarket()
        HapticManager.notification(type: .success)
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
    
    
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portafolioCoins: [CoinModel]) -> [StadisticasModelo] {
        var stas: [StadisticasModelo] = []
        
        guard let data = marketDataModel else {
            return stas
        }
        let portafolioValue = portafolioCoins.map  ({ $0.currentHoldingsValue}) .reduce(0, +)
        
        let previusValue = portafolioCoins.map { (coin) -> Double in
            let currenceValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H!  / 100
            let previusValue = currenceValue / (1 + percentChange)
            return previusValue
        }
            .reduce(0, +)
        let percentageChangePortafolio = ((portafolioValue - previusValue) / previusValue) * 100
                         
        
        let marketCap = StadisticasModelo(title: "Portafolio Value", value: portafolioValue.asNumeroString(), percentageChange: percentageChangePortafolio)
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

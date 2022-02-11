//
//  HomeViewModel.swift
//  CrytoWallet
//
//  Created by Isaac on 09/02/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portafolioCoin: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
   addSubscribers()
    }
    
    func addSubscribers() {
      
        
        $searchText
            .combineLatest(dataService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
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
    
}

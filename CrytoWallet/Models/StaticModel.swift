//
//  StaticModel.swift
//  CrytoWallet
//
//  Created by Isaac on 16/02/22.
//

import Foundation

struct StadisticasModelo: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
}


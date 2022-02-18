//
//  Double.swift
//  CrytoWallet
//
//  Created by Isaac on 09/02/22.
//

import Foundation

extension Double {
    
    ///Extension para convertir de 2 a 6 decimales
    /// ```
    /// Ejemplos de la extension:
    /// Convertir 1234.56 a $1,234.56
    /// Convertir 12.3456 a $12.3456
    /// Convertir 0.123456 a $0.123456
    /// ```
   
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    func currency6Decimal() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    ///Extension para convertir de a solo 2 decimales en String
    /// ```
    /// Ejemplos de la extension:
    /// Convertir 1234.5612 a ""1,234.56"
    
    /// ```
    func asNumeroString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPorcentajeString() -> String {
        return asNumeroString() + "%"
    }
    
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumeroString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumeroString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumeroString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumeroString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumeroString()

        default:
            return "\(sign)\(self)"
        }
    }
}

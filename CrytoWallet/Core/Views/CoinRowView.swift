//
//  CoinRowView.swift
//  CrytoWallet
//
//  Created by Isaac on 09/02/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingCurrency: Bool
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            
            if showHoldingCurrency {
                
                centerColumn
            }
            rightColumn
        }
        
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingCurrency: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldingCurrency: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        

    }
}



extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(width: 35)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.currency6Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumeroString())
            
        }
        .foregroundColor(Color.theme.accent)
    }
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.currency6Decimal())")
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPorcentajeString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green :
                        Color.theme.red
                    
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
}

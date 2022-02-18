//
//  EstadisticasView.swift
//  CrytoWallet
//
//  Created by Isaac on 16/02/22.
//

import SwiftUI

struct EstadisticasView: View {
    
    let stas: StadisticasModelo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stas.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stas.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stas.percentageChange ?? 0) >= 0 ? 0 : 180))
            
            Text(stas.percentageChange?.asPorcentajeString() ?? "" )
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stas.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stas.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct EstadisticasView_Previews: PreviewProvider {
    static var previews: some View {
        EstadisticasView(stas: dev.state1)
    }
}

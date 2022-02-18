//
//  HomeStaView.swift
//  CrytoWallet
//
//  Created by Isaac on 16/02/22.
//

import SwiftUI

struct HomeStaView: View {
   
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.stadisticas) {stas in
                EstadisticasView(stas: stas)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStaView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStaView(showPortfolio: .constant(false))
    }
}

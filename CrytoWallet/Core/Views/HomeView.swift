//
//  HomeView.swift
//  CrytoWallet
//
//  Created by Isaac on 08/02/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortafolio: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                HomeHeader
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
    }
}

extension HomeView {
    private var HomeHeader: some View {
        HStack{
            CircleButtonView(iconName: showPortafolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortafolio)
                )
            Spacer()
            Text(showPortafolio ? "PORTAFOLIO" : "PRECIOS EN VIVO")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
            //Hacemos la animacion de girar 180º
                .rotationEffect(Angle(degrees: showPortafolio ? 180: 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortafolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
}

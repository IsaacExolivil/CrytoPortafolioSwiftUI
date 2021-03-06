//
//  HomeView.swift
//  CrytoWallet
//
//  Created by Isaac on 08/02/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortafolio: Bool = false
    @State private var showPortafolioView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortafolioView, content: {
                    PortafolioView()
                        .environmentObject(vm)
                })
               
            
            VStack {
                HomeHeader
                HomeStaView(showPortfolio: $showPortafolio)
                SearchBarView(searchText: $vm.searchText)
                
                
                columnTitles
                
                if !showPortafolio {
                    portafolioCoinList
                        .transition(.move(edge: .trailing))
                }
                if showPortafolio {
                 
                    allCoinList
                    .transition(.move(edge: .leading))
     
                    
                }
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
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    
    private var HomeHeader: some View {
        HStack{
            CircleButtonView(iconName: showPortafolio ? "info" :
                                "plus"
                                
            )
                .onTapGesture {
                    if !showPortafolio {
                        showPortafolioView.toggle()
                    }
                }
               
           
                .background(
                    CircleButtonAnimationView(animate: $showPortafolio)
                   
                )
             
                
            
                
            Spacer()
            Text(showPortafolio ? "PRECIOS EN VIVO" : "PORTAFOLIO")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
            //Hacemos la animacion de girar 180??
                
                .rotationEffect(Angle(degrees: showPortafolio ? 0: 180))
                .onTapGesture {
                    
                    withAnimation(.spring()) {
                       
                        showPortafolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingCurrency: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    
            
         }
        }
        .listStyle(PlainListStyle())
    }
    
    
    private var portafolioCoinList: some View {
        List {
            ForEach(vm.portafolioCoin) {
                coin in
                CoinRowView(coin: coin, showHoldingCurrency: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    }
        }
        .listStyle(PlainListStyle())
    }
    private var columnTitles: some View {
        HStack {
            Text("Coin")
        
            Spacer()
            if !showPortafolio {
              Text("hold")
            }
           
            Text("Price")
           
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
            Button(action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
                
            }, label: {
                Image(systemName: "goforward")
            })
                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}

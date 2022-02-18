//
//  PortafolioView.swift
//  CrytoWallet
//
//  Created by Isaac on 17/02/22.
//

import SwiftUI

struct PortafolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantifyText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portafolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portafolio🔥")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
          
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingNavBarButtons
            }
            
        })
            .onChange(of: vm.searchText, perform: {value in
                if value == "" {
                    removeSelectCoin()
                }
            })
        }
    }
}

struct PortafolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortafolioView()
            .preferredColorScheme(.dark)
            .environmentObject(dev.homeVM)
    }
}

extension PortafolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) {
                    coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.pink : Color.blue, lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        })
    }
    
    private func getCurrentValue() -> Double {
        if let quantify = Double(quantifyText) {
            return quantify * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portafolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.currency6Decimal() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding: ")
                Spacer()
                TextField("Ex: 1.4", text: $quantifyText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue().currency6Decimal())
            }
        }
        .padding()
        .font(.headline)
    }
    private var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            //Cambiar en un futuro la iamgen de guardar
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
                .opacity(
                    (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantifyText)) ?
                    1.0 : 0.0
                )

        }
        .font(.headline)
    }
    private func saveButtonPressed() {
        guard let coin = selectedCoin else { return }
        
        //save to portafolio
        
        //show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectCoin()
        }
        //hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkMark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    private func removeSelectCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}

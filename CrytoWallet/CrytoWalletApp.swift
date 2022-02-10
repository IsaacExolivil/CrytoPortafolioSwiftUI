//
//  CrytoWalletApp.swift
//  CrytoWallet
//
//  Created by Isaac on 08/02/22.
//

import SwiftUI

@main
struct CrytoWalletApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}

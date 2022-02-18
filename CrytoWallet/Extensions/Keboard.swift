//
//  Keboard.swift
//  CrytoWallet
//
//  Created by Isaac on 16/02/22.
//
import Foundation
import SwiftUI


extension UIApplication {
    
    func endEditing() {
        
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

//
//  UIApplication.swift
//  CrytoWallet
//
//  Created by Isaac on 11/02/22.
//
import Foundation
import SwiftUI

extension UIApplication {
    
    func Editing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

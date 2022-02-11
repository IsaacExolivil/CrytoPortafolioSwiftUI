//
//  CoinImageService.swift
//  CrytoWallet
//
//  Created by Isaac on 10/02/22.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folder = "Coin_Imagenes"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
        
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folder){
            image = savedImage
            print("guardo la imagen del fileManager")
        } else {
            DowloadCoinImage()
            print("descargando imagen")
        }
    }
    private func DowloadCoinImage() {
        guard let url = URL(string: coin.image ?? "") else { return }
        
        imageSubscription = NetworkingManager.dowload(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            
        
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnImage) in
                guard let self = self, let dowloadImage = returnImage  else { return }
                self.image = returnImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: dowloadImage, imageName: self.imageName, folderName: self.folder)
            })
    }
}

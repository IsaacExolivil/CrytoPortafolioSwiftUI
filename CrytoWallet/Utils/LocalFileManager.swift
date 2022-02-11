//
//  LocalFileManager.swift
//  CrytoWallet
//
//  Created by Isaac on 10/02/22.
//

import Foundation
import UIKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        //Creamos la carpeta
        createFolderIfNeed(folderName: folderName)
        
        //obetemos al ruta de la imagen
        guard
            let data = image.pngData(),
            let url = getURLForImage(imagenName: imageName, foldername: folderName)
        else { return }
        
        //Guardamos la imagen la ruta
        do {
        try data.write(to: url)
        } catch let error {
            print("Errro al guardar la imagen \(error)")
        }
    }
    
    func getImage(imageName: String, folderName: String) ->UIImage? {
        guard let url = getURLForImage(imagenName: imageName, foldername: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
                  return nil
              }
        return UIImage(contentsOfFile: url.path)
    }
    
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return  nil
        }
        return url.appendingPathComponent(folderName)
    }
    private func getURLForImage(imagenName: String, foldername: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: foldername) else {
            return nil
        }
        return folderURL.appendingPathComponent(imagenName + ".png")
    }
    
    private func createFolderIfNeed(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error al crear el directorio: \(folderName).\(error)")
            }
        }
    }
}

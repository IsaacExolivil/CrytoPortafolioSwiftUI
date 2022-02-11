//
//  NetworkingManager.swift
//  CrytoWallet
//
//  Created by Isaac on 10/02/22.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case desconocido
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[:(] Mala rspuesta de la URL: \(url)"
            case .desconocido: return "[?????] Desconocido un error ocurrio"
            }
        }
    }
    
    static func dowload(url: URL) -> AnyPublisher<Data, Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw NetworkingError.badURLResponse(url: url)
                 
              }
        return output.data
    }
    
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

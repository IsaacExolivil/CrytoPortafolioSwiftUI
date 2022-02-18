//
//  PortafolioDataService.swift
//  CrytoWallet
//
//  Created by Isaac on 17/02/22.
//

import Foundation
import CoreData

class PortafolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortafolioContainer"
    //contante entity viene de CoreData
    private let entityName: String = "PortafolioEntity"
    
    @Published var saveEntities: [PortafolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
        if let error = error {
            print("Error al cargar core data el error es: \(error)")
            
        }
            self.getPortafolio()
        }
    }
    //MARK: PUBLIC
    
    func updatePortafolio(coin: CoinModel, amount: Double) {
        //checar si ya esta en el portafolio
        if let entity = saveEntities.first(where: { $0.coinID == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVADO
    private func getPortafolio() {
        //asiganamos la entidad
        let request = NSFetchRequest<PortafolioEntity>(entityName: entityName)
        do {
           saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error entities. \(error)")
        }
    }
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortafolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortafolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    private func delete(entity: PortafolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error al guardar en core data \(error)")
        }
    }
    private func applyChanges() {
        save()
        getPortafolio()
    }
}

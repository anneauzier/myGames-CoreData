//
//  ConsolesManager.swift
//  myGames
//
//  Created by Anne Victoria Batista Auzier on 20/12/23.
//

import CoreData

class ConsolesManager {
    static let shared = ConsolesManager()
    var consoles: [Console] = []
    
    func loadConsoles(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescription]

        do {
            consoles = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
        
        do {
            try context.save()
            consoles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

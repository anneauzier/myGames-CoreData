//
//  GamesTableViewController.swift
//  myGames
//
//  Created by Anne Victoria Batista Auzier on 19/12/23.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    private var fetchedResultController: NSFetchedResultsController<Game>!
    private var placeholder = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholder.text = "Você ainda não possui jogos cadastrados. \nAperte o '+' e cadastre."
        placeholder.numberOfLines = 0
        placeholder.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGames()
    }
    
    private func loadGames() {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescription]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "gameSegue" {
            let vc = segue.destination as! GameViewController
            
            if let games = fetchedResultController.fetchedObjects {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? placeholder : nil
        
        return count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.lbTitle.text = game.title
        cell.lbConsole.text = game.console?.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else { return }
            context.delete(game)
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
    }
}


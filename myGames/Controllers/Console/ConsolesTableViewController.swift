//
//  ConsolesTableViewController.swift
//  myGames
//
//  Created by Anne Victoria Batista Auzier on 19/12/23.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    var consolesManager = ConsolesManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()        
    }

    private func loadConsoles() {
        consolesManager.loadConsoles(with: context)
        tableView.reloadData()
    }
    
    private func showAlert(with console: Console?) {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Nome da plataforma"
            if let name = console?.name {
                textfield.text = name
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { action in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            
            do {
                try self.context.save()
                self.loadConsoles()
            } catch {
                print(error.localizedDescription)
            }

        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(named: "second")
        present(alert, animated: true)
    }

    @IBAction func addConsole(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return consolesManager.consoles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
        
        let consoles = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = consoles.name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consolesManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

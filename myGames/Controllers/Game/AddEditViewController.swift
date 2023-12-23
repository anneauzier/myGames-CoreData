//
//  AddEditViewController.swift
//  myGames
//
//  Created by Anne Victoria Batista Auzier on 19/12/23.
//

import UIKit

class AddEditViewController: UIViewController {
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    
    var game: Game!
    var consolesManager = ConsolesManager.shared
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game != nil {
            title = "Editar"
            btAddEdit.setTitle("Alterar", for: .normal)
            tfTitle.text = game.title
            
            if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console) {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
        }
        
        prepareConsoleTextField()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsoles(with: context)
    }
    
    private func prepareConsoleTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone =  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btDone]
        
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolbar
    }
    
    
    @objc func cancel() {
        tfConsole.resignFirstResponder()
    }
    
    @objc func done() {
        
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
        cancel()
    }

    @IBAction func addEdit(_ sender: UIButton) {
        if game == nil {
            game = Game(context: context)
        }
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        
        if let text = tfConsole.text {
            if !text.isEmpty {
                let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
                game.console = console
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }

        navigationController?.popViewController(animated: true)
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

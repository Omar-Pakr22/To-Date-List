//
//  ViewController.swift
//  To-Do-List
//
//  Created by Omar Pakr on 10/12/2023.
//

import UIKit

class ViewController: UIViewController {
    var items = [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTools()
    }
    private func initTools(){
        tableView.delegate = self
        tableView.dataSource = self
        if let savedItems = UserDefaults.standard.stringArray(forKey: "todoItems") {
            items = savedItems
        }
    }
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
        }
        let save = UIAlertAction(title: "Save", style: .default) { (save) in
            self.items.append(textField.text!)
            self.saveItemsToUserDefaults()
            self.tableView.reloadData()
        }
        alert.addTextField { (text) in
            textField = text
            textField.placeholder = "Add New item"
        }
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
    }
    private func saveItemsToUserDefaults() {
        UserDefaults.standard.set(items, forKey: "todoItems")
    }
}
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.isEmpty {
            emptyView.isHidden = false
            tableView.isHidden = true
            return 0
        }else {
            emptyView.isHidden = true
            tableView.isHidden = false
            return items.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell", for: indexPath) as! CustomTableViewCell
        cell.toDoLabel.text = items[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {  _,_,completion in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveItemsToUserDefaults()
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let congig = UISwipeActionsConfiguration(actions: [deleteAction])
        return congig
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sendActin = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            print("Send a message to \(self.items[indexPath.row])")
            completion(true)
        }
        sendActin.image = UIImage(systemName: "envelope")
        sendActin.backgroundColor = .systemMint
        let congig = UISwipeActionsConfiguration(actions: [sendActin])
        return congig
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

